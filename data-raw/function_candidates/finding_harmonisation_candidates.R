library(dplyr)
devtools::load_all()
source(here::here("data-raw", "function_candidates", "create_variable_catalog.R"))
source(here::here("data-raw", "function_candidates", "search_variables.R"))
gesis_dir <- here::here("data-raw", "gesis")
gesis_files <- dir(gesis_dir)
gesis_files <- gesis_files[which(grepl(".sav", gesis_files))]

catalog <- create_variable_catalog(
  survey_files = here::here("data-raw", "gesis", gesis_files),
  dataset_id = substr(gesis_files, 1, 6)
)


identity_vars <- search_variables(
  catalog,
  "attach"
)

trust_vars <- search_variables(
  catalog,
  "trust|parliament|commission"
) %>%
  filter(file %in% unique(identity_vars$file)[-7])

nuts_vars <- search_variables(
  catalog,
  "nuts|REGION I|country"
)

p7_vars <- search_variables_by_code(
  catalog,
  "P7"
)

p6_vars <- search_variables_by_code(
  catalog,
  "P6"
)

isocntry <- search_variables_by_code(catalog, "isocntry")

wex_vars <- search_variables_by_code(
  catalog,
  "wex|wextra"
)

test <- catalog %>% filter(file == "ZA4529_v3-0-1.sav")


identity_vars %>%
  select(1:5) %>%
  print(n = 21)

trust_vars %>%
  select(
    dataset_id,
    var_name,
    var_label
  )

unique(trust_vars$file)

eb_waves <- read_surveys(
  survey_paths = here::here("data-raw", "gesis", unique(identity_vars$file)),
  .f = "read_spss"
)


unique(identity_vars$file)

tttt <- metadata_create(eb_waves[[1]])

attachment_variables <- identity_vars %>%
  mutate(
    concept = case_when(
      stringr::str_detect(
        var_label,
        "TOWN|CITY"
      ) ~ "attachment_town",
      stringr::str_detect(
        var_label,
        "COUNTRY"
      ) ~ "attachment_country",
      stringr::str_detect(
        var_label,
        "EUROPEAN UNION"
      ) ~ "attachment_eu",
      stringr::str_detect(
        var_label,
        "ATTACHMENT TO EUROPE$|ATTACHMENT TO: EUROPE$"
      ) ~ "attachment_europe",
      TRUE ~ NA_character_
    )
  )

# different coding
ZA4529 <- read_survey(here::here("data-raw", "gesis", "ZA4529_v3-0-1.sav"))
ZA7780 <- read_survey(here::here("data-raw", "gesis", "ZA7780_v2-0-0.sav"))

ZA8905 <- read_survey(here::here("data-raw", "gesis", "ZA8905_v1-0-0.sav"))
ZA8843 <- read_survey(here::here("data-raw", "gesis", "ZA8843_v1-0-0.sav"))
ZA8779 <- read_survey(here::here("data-raw", "gesis", "ZA8779_v1-0-0.sav"))

surveys <- list(
  ZA8779 = ZA8779,
  ZA8843 = ZA8843,
  ZA8905 = ZA8905
)

ZA8905$survey
ZA8779_catalogue <- metadata_create(ZA8779)
ZA8843_catalogue <- metadata_create(ZA8843)
ZA8905_catalogue <- metadata_create(ZA8905)


de_ratio_ZA8779 <- ZA8779 %>%
  select(isocntry, w1de) %>%
  filter(isocntry %in% c("DE-W", "DE-E")) %>%
  group_by(isocntry) %>%
  summarise(w1de = mean(w1de))

de_ratio_ZA8843 <- ZA8843 %>%
  select(isocntry, w1de) %>%
  filter(isocntry %in% c("DE-W", "DE-E")) %>%
  group_by(isocntry) %>%
  summarise(w1de = mean(w1de))


de_ratio_ZA8905 <- ZA8905 %>%
  select(isocntry, w1de) %>%
  filter(isocntry %in% c("DE-W", "DE-E")) %>%
  group_by(isocntry) %>%
  summarise(w1de = mean(w1de))

binary_trust_code <- function(x) {
  dplyr::case_when(
    grepl("not to", as_character(x)) ~ 0,
    grepl("end to trust", as_character(x)) ~ 1,
    .default = NA_integer_
  )
}

attachment_dfs <- purrr::imap(
  surveys,
  function(survey_data, survey_name) {
    survey_data <- survey_data %>%
      mutate(
        region_malta = dplyr::if_else(
          isocntry == "MT",
          "MT00",
          NA_character_
        )
      ) %>%
      mutate(
        across(
          starts_with("region_"),
          ~ as.character(as_factor(.x))
        )
      )

    region_long <- survey_data %>%
      select(
        rowid,
        country_code = isocntry,
        w1,
        starts_with("region_")
      ) %>%
      tidyr::pivot_longer(
        cols = starts_with("region_"),
        names_to = "region_var",
        values_to = "region"
      ) %>%
      filter(
        !is.na(region),
        !grepl("^Inap", region)
      ) %>%
      select(
        rowid,
        country_code,
        region
      )

    survey_data %>%
      select(
        rowid,
        country_code = isocntry,
        w1,
        age_exact = d11,
        attach_locality = qc1_1,
        attach_country = qc1_2,
        attach_eu = qc1_3,
        attach_europe = qc1_4
      ) %>%
      left_join(
        region_long,
        by = c("rowid", "country_code")
      ) %>%
      mutate(
        survey = survey_name
      ) %>%
      mutate(
        across(
          starts_with("attach_"),
          as_numeric,
          .names = "{.col}_num"
        )
      ) %>%
      mutate(
        across(
          ends_with("_num"),
          ~ replace(.x, .x == 5, NA_real_)
        )
      ) %>%
      mutate(
        across(
          ends_with("_num"),
          ~ .x * w1
        )
      ) %>%
      mutate(
        across(
          starts_with("attach_") & !ends_with("_num"),
          as_factor
        ),
        region = as_factor(region)
      )
  }
)

attachment_df <- bind_rows(attachment_dfs)

code_table <- attachment_df %>%
  mutate(survey_id = substr(rowid, 1, 6)) %>%
  select(survey_id, attach_eu, attach_eu_num) %>%
  distinct_all()

trust_dfs <- purrr::imap(
  surveys,
  function(survey_data, survey_name) {
    survey_data <- survey_data %>%
      mutate(
        region_malta = dplyr::if_else(
          isocntry == "MT",
          "MT00",
          NA_character_
        )
      ) %>%
      mutate(
        across(
          starts_with("region_"),
          ~ as.character(as_factor(.x))
        )
      )

    region_long <- survey_data %>%
      select(
        rowid,
        country_code = isocntry,
        starts_with("region_")
      ) %>%
      tidyr::pivot_longer(
        cols = starts_with("region_"),
        names_to = "region_var",
        values_to = "region"
      ) %>%
      filter(
        !is.na(region),
        !grepl("^Inap", region)
      ) %>%
      select(
        rowid,
        country_code,
        region
      )

    survey_metadata <- metadata_create(survey_data)

    rename_table <- survey_metadata %>%
      filter(
        grepl("^qa6_", var_name_orig)
      ) %>%
      mutate(
        new_name = janitor::make_clean_names(
          var_label_orig
        )
      ) %>%
      select(
        var_name_orig,
        new_name
      )

    survey_data <- survey_data %>%
      rename_with(
        ~ rename_table$new_name[
          match(.x, rename_table$var_name_orig)
        ],
        .cols = starts_with("qa6_")
      )

    trust_vars <- names(survey_data)[
      grepl(
        "trust|confidence",
        names(survey_data),
        ignore.case = TRUE
      )
    ]

    survey_data %>%
      select(
        rowid,
        country_code = isocntry,
        w1,
        age_exact = d11,
        all_of(trust_vars)
      ) %>%
      left_join(
        region_long,
        by = c("rowid", "country_code")
      ) %>%
      mutate(
        survey = survey_name
      ) %>%
      mutate(
        across(
          all_of(trust_vars),
          binary_trust_code,
          .names = "{.col}_num"
        )
      ) %>%
      mutate(
        across(
          ends_with("_num"),
          ~ .x * w1
        )
      ) %>%
      mutate(
        across(
          all_of(trust_vars),
          as_factor
        ),
        region = as_factor(region)
      )
  }
)

trust_df <- bind_rows(trust_dfs)

eu_attachment <- attachment_df %>%
  select(
    country_code,
    region,
    ends_with("_num")
  ) %>%
  group_by(
    country_code,
    region
  ) %>%
  summarise(
    across(
      ends_with("_num"),
      ~ mean(.x, na.rm = TRUE)
    ),
    .groups = "drop"
  ) %>%
  arrange(
    attach_eu_num
  ) %>%
  mutate(
    rank_region_attach_eu = row_number()
  ) %>%
  mutate(region_eu_to_country = attach_country_num - attach_eu_num) %>%
  arrange(-region_eu_to_country)

eu_trust <- trust_df %>%
  select(
    country_code,
    region,
    ends_with("_num")
  ) %>%
  group_by(
    country_code,
    region
  ) %>%
  mutate(
    across(
      ends_with("_num"),
      ~ ifelse(.x == 3, NA, .x)
    )
  ) %>%
  summarise(
    across(
      ends_with("_num"),
      ~ mean(.x, na.rm = TRUE)
    ),
    .groups = "drop"
  ) %>%
  arrange(
    desc(trust_in_institutions_european_union_num)
  ) %>%
  mutate(
    rank_region_trust_eu = row_number()
  )


eu_attachment_by_country <- attachment_df %>%
  select(
    country_code,
    ends_with("_num")
  ) %>%
  group_by(
    country_code,
  ) %>%
  summarise(
    across(
      ends_with("_num"),
      ~ mean(.x, na.rm = TRUE)
    ),
    .groups = "drop"
  ) %>%
  arrange(
    attach_eu_num
  ) %>%
  mutate(
    rank_attach_eu = row_number()
  ) %>%
  mutate(eu_to_country = attach_country_num - attach_eu_num) %>%
  arrange(-eu_to_country) %>%
  mutate(region = "all")

eu_trust_by_country <- trust_df %>%
  select(
    country_code,
    ends_with("_num")
  ) %>%
  group_by(
    country_code,
  ) %>%
  summarise(
    across(
      ends_with("_num"),
      ~ mean(.x, na.rm = TRUE)
    ),
    .groups = "drop"
  ) %>%
  mutate(region = "all") %>%
  mutate(
    nat_parl_deficit = trust_in_institutions_european_union_num - trust_in_institutions_national_parliament_num,
    nat_govt_deficit = trust_in_institutions_european_union_num - trust_in_institutions_national_government_num
  ) %>%
  arrange(
    desc(nat_parl_deficit)
  ) %>%
  mutate(
    rank_attach_eu = row_number()
  )

names(eu_trust_by_country)


hu_eu_attachment <- eu_attachment %>%
  filter(country_code == "HU") %>%
  bind_rows(eu_attachment_by_country) %>%
  arrange(
    attach_eu_num
  ) %>%
  mutate(
    rank = row_number()
  )


save(eu_attachment, hu_eu_attachment, eu_attachment_by_country, file = "eu_attach.rda")


eu_country_attachment_ZA8843 <- attachment_df_ZA8843 %>%
  select(
    country_code,
    ends_with("_num")
  ) %>%
  group_by(
    country_code,
  ) %>%
  summarise(
    across(
      ends_with("_num"),
      ~ mean(.x, na.rm = TRUE)
    ),
    .groups = "drop"
  ) %>%
  arrange(
    attach_eu_num
  ) %>%
  mutate(
    rank_attach_eu = row_number()
  ) %>%
  mutate(eu_to_country = attach_country_num - attach_eu_num) %>%
  arrange(-eu_to_country)
