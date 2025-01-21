search_variables <- function(
    catalog,
    pattern,
    ignore_case = TRUE
) {
  
  stopifnot(inherits(catalog, "survey_catalog"))
  
  catalog %>%
    dplyr::filter(
      stringr::str_detect(
        var_label,
        stringr::regex(
          pattern,
          ignore_case = ignore_case
        )
      )
    )
}

source(here::here("data-raw", "function_candidates", "create_variable_catalog.R"))
gesis_dir <- here::here("data-raw", "gesis")
gesis_files <- dir(gesis_dir)
gesis_files <- gesis_files[which(grepl(".sav", gesis_files))]

catalog <- create_variable_catalog(
  survey_files = here::here("data-raw", "gesis", gesis_files),
  dataset_id = substr(gesis_files, 1, 6)
)

library(dplyr)
trust_vars <- search_variables(
  catalog,
  "trust|parliament|commission"
)
identity_vars <- search_variables(
  catalog,
  "attach"
)

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

test  <- catalog %>% filter ( file == "ZA4529_v3-0-1.sav")


identity_vars %>%
  select(1:5) %>% print (n=21)

trust_vars %>%
  select(
    dataset_id,
    var_name,
    var_label
  )

unique(trust_vars$file)

eb_waves <- read_surveys(
  survey_paths = here::here("data-raw", "gesis", unique(identity_vars$file)), 
  .f = "read_spss")


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
ZA8843  <- read_survey(here::here("data-raw", "gesis", "ZA8843_v1-0-0.sav"))
ZA8779  <- read_survey(here::here("data-raw", "gesis", "ZA8779_v1-0-0.sav"))

surveys <- list(
  ZA8779 = ZA8779,
  ZA8843 = ZA8843,
  ZA8905 = ZA8905
)

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
        starts_with("region_")
      ) %>%
      pivot_longer(
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
          starts_with("attach_")  & !ends_with("_num"),
          as_factor
        ),
        region = as_factor(region)
      )
  }
)

attachment_df <- bind_rows(attachment_dfs)

ZA8905_catalog <- metadata_create(ZA8905)
ZA8843_catalog <- metadata_create(ZA8843)
ZA8779_catalog <- metadata_create(ZA8779)
ZA7780_catalog <- metadata_create(ZA7780)


str(attachment_dfs)

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
  mutate ( region_eu_to_country = attach_country_num - attach_eu_num ) %>%
  arrange(-region_eu_to_country)


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
  mutate ( eu_to_country = attach_country_num - attach_eu_num ) %>%
  arrange(-eu_to_country) %>%
  mutate ( region = "all")


hu_eu_attachment <- eu_attachment %>% 
  filter ( country_code == "HU") %>%
  bind_rows( eu_attachment_by_country ) %>%
  arrange(
    attach_eu_num
  ) %>%
  mutate(
    rank = row_number()
  )
  




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
  mutate ( eu_to_country = attach_country_num - attach_eu_num ) %>%
  arrange(-eu_to_country)
