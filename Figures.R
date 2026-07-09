## ============================================================
## NHLE Paper — Figure code
## All figures use corrected NHLE = UHE + (budget - ex)
## Run from project root after sourcing corrected data files
## ============================================================

library(ggplot2)
library(dplyr)
library(tidyr)
library(forcats)
library(patchwork)   # install.packages("patchwork") if needed
library(here)
library(data.table)

## ── Colour palette (viridis) ─────────────────────────────────────────────────
## install.packages("viridis") if needed
library(viridis)

VIR <- viridis(7, option = "D")   # 7 stops of the main viridis palette
COL_FEMALE  <- VIR[6]   # yellow-green  (women)
COL_MALE    <- VIR[2]   # blue-purple   (men)
COL_HEALTHY <- VIR[7]   # bright yellow (healthy years)
COL_ULE     <- VIR[4]   # teal          (unhealthy years lived)
COL_DEAD    <- VIR[1]   # dark purple   (dead years)
COL_MORT    <- VIR[5]   # green         (mortality effect)
COL_PREV    <- VIR[3]   # blue-teal     (morbidity effect)

BUDGET <- 60   # omega - a = 110 - 50

## ── Load corrected data ────────────────────────────────────────────────────────
sull  <- fread(here("data","Corrected","sull_corrected.csv"))
cal   <- fread(here("data","Corrected","cal_corrected.csv"))
lng   <- fread(here("data","Corrected","lng_corrected.csv"))
gaps  <- fread(here("data","Corrected","gaps_all.csv"))
decomp <- fread(here("data","Corrected","decomp_all.csv"))

## Dimension labels (used in facets)
dim_labs <- c(ADL = "ADL", CHR = "Chronic morbidity",
              GALI = "GALI", SR = "Self-rated health")

## Country order: sort Sullivan female NHLE_GALI descending (geographic proxy)
country_order <- sull %>%
  filter(sex == "female") %>%
  arrange(desc(NHLE_GALI)) %>%
  pull(country)



## ─────────────────────────────────────────────────────────────────────────────
## FIGURE 1: Stacked bar — NHLE decomposition by sex for selected countries
##   Each bar = 60 years split into: HE (healthy) | UHE (unhealthy lived) | Dead
##   Dimension: GALI (most clean reversal); method: Sullivan
## ─────────────────────────────────────────────────────────────────────────────

## Select 10 representative countries spanning E/W/N/S Europe and mortality range
sel_countries <- c("EST","LVA","LTU","BGR","HUN","POL","PRT","ITA","FRA","DNK","SWE","CHE")

fig1_data <- sull %>%
  filter(country %in% sel_countries) %>%
  mutate(
    HE    = HE_GALI,        # healthy years
    UHE   = UHE_GALI,       # unhealthy years lived
    Dead  = BUDGET - ex,    # years lost to death
    country = factor(country, levels = rev(sel_countries))
  ) %>%
  select(country, sex, HE, UHE, Dead) %>%
  pivot_longer(c(HE, UHE, Dead), names_to = "component", values_to = "years") %>%
  mutate(
    component = factor(component, levels = c("Dead", "UHE", "HE")),
    sex       = factor(sex, levels = c("male", "female"),
                       labels = c("Men", "Women"))
  )

fig1 <- ggplot(fig1_data, aes(x = years, y = country, fill = component)) +
  geom_col(width = 0.6, position = "stack") +
  geom_vline(xintercept = BUDGET, linetype = "dashed", colour = "black", linewidth = 0.4) +
  facet_wrap(~sex, ncol = 2) +
  scale_fill_manual(
    values = c(HE = COL_HEALTHY, UHE = COL_ULE, Dead = COL_DEAD),
    labels = c(HE  = "Healthy life (HLE)",
               UHE = "Unhealthy life (UHE)",
               Dead = "Healthy years lost to death"),
    breaks = c("HE","UHE","Dead")
  ) +
  scale_x_continuous(breaks = seq(0, 60, 10), expand = c(0, 0.5)) +
  labs(
    title  = "Figure 1. Decomposition of the lifespan budget into HLE, UHE, and\nhealthy years lost to death, age 50–110, selected European countries, 2017",
    subtitle = "Health dimension: GALI (activity limitations) | Method: Sullivan",
    x      = "Years (age 50 to 110)",
    y      = NULL,
    fill   = NULL,
    caption = "Source: SHARE Wave 7 and HMD period life tables, 2017."
  ) +
  theme_bw(base_size = 10) +
  theme(
    legend.position   = "bottom",
    legend.key.size   = unit(0.4, "cm"),
    strip.background  = element_rect(fill = "grey92"),
    strip.text        = element_text(face = "bold"),
    panel.grid.major.y = element_blank(),
    plot.title        = element_text(size = 10, face = "bold"),
    plot.subtitle     = element_text(size = 9, colour = "grey40")
  )

fig1
ggsave(here("figs","fig1_stacked_decomp.pdf"), fig1, width = 8, height = 5.5, device = cairo_pdf)
ggsave(here("figs","fig1_stacked_decomp.png"), fig1, width = 8, height = 5.5, dpi = 300)

## ─────────────────────────────────────────────────────────────────────────────
## FIGURE 2: Scatter — gender gap in ULE vs gender gap in NHLE
##   One panel per health dimension; methods overlaid as shapes/colours
##   Quadrant shading: upper-left = classic paradox zone; lower-right = reversal
## ─────────────────────────────────────────────────────────────────────────────

## Label only notable outlier countries, using Sullivan values only to avoid
## triple-stacked labels (one label per country per panel is sufficient)
label_countries <- c("EST","LVA","LTU","BGR","HUN","PRT","CHE","SVK","SWE","ESP","GRC")

fig2_data <- gaps %>%
  pivot_longer(
    cols      = c(gULE_ADL, gULE_CHR, gULE_GALI, gULE_SR,
                  gNHLE_ADL, gNHLE_CHR, gNHLE_GALI, gNHLE_SR),
    names_to  = c("measure","dimension"),
    names_pattern = "g(ULE|NHLE)_(.*)"
  ) %>%
  pivot_wider(names_from = measure, values_from = value) %>%
  mutate(
    dimension = factor(dimension,
                       levels = c("ADL","CHR","GALI","SR"),
                       labels = c("ADL","Chronic morbidity","GALI","Self-rated health")),
    method    = factor(method, levels = c("Sullivan","CAL","Multistate")),
    ## Only attach a label to the Sullivan row — avoids triple-stacked country names
    label = ifelse(country %in% label_countries & method == "Sullivan",
                   country, NA_character_)
  )

fig2 <- ggplot(fig2_data, aes(x = ULE, y = NHLE, colour = method, shape = method)) +
  ## shaded reversal zone: ULE > 0 and NHLE < 0
  annotate("rect", xmin = 0, xmax = Inf, ymin = -Inf, ymax = 0,
           fill = VIR[2], alpha = 0.25) +
  ## reference lines
  geom_hline(yintercept = 0, colour = "black", linewidth = 0.4) +
  geom_vline(xintercept = 0, colour = "black", linewidth = 0.4) +
  ## points (all methods)
  geom_point(size = 1.8, alpha = 0.85) +
  ## labels only on Sullivan points → one label per country per panel
  ggrepel::geom_text_repel(
    data = ~ subset(., method == "Sullivan"),
    aes(label = label), size = 2.5, colour = "grey25",
    min.segment.length = 0.2, max.overlaps = 20,
    box.padding = 0.3, show.legend = FALSE, na.rm = TRUE
  ) +
  facet_wrap(~dimension, nrow = 2, scales = "free") +
  scale_colour_manual(values = c(Sullivan = VIR[2], CAL = VIR[5], Multistate = VIR[7])) +
  scale_shape_manual(values  = c(Sullivan = 16,     CAL = 17,     Multistate = 15)) +
  labs(
    title    = "Figure 2. Gender gap in ULE versus gender gap in NHYE (female\u2009\u2212\u2009male)",
    subtitle = "Shaded area = reversal zone: women have higher ULE but lower NHYE than men",
    x        = "Gender gap in ULE (years, female \u2212 male)",
    y        = "Gender gap in NHYE (years, female \u2212 male)",
    colour   = "Method", shape = "Method",
    caption  = paste0("Country labels shown for Sullivan estimates only. ",
                      "Age 50, European countries, 2017. Source: SHARE Wave 7 and HMD.")
  ) +
  theme_bw(base_size = 10) +
  theme(
    legend.position  = "bottom",
    strip.background = element_rect(fill = "grey92"),
    strip.text       = element_text(face = "bold"),
    plot.title       = element_text(size = 10, face = "bold"),
    plot.subtitle    = element_text(size = 9, colour = "grey40")
  )

fig2
## ggrepel needed: install.packages("ggrepel")
ggsave(here("figs","fig2_gap_scatter.pdf"), fig2, width = 8, height = 7, device = cairo_pdf)
ggsave(here("figs","fig2_gap_scatter.png"), fig2, width = 8, height = 7, dpi = 300)



## ─────────────────────────────────────────────────────────────────────────────
## FIGURE S1-S2 (Supplementary): Stacked bars for CAL and Multistate
##   Same structure as Fig 1 but for the other two methods.
##   Here we show that the three-component pattern is
##   consistent across methods without crowding the main text.
## ─────────────────────────────────────────────────────────────────────────────

make_stacked_fig <- function(data, method_label, sel_countries, title_str) {
  data %>%
    filter(country %in% sel_countries) %>%
    mutate(
      HE   = HE_GALI,
      UHE  = UHE_GALI,
      Dead = BUDGET - ex,
      country = factor(country, levels = rev(sel_countries)),
      sex     = factor(sex, levels = c("male","female"), labels = c("Men","Women"))
    ) %>%
    select(country, sex, HE, UHE, Dead) %>%
    pivot_longer(c(HE, UHE, Dead), names_to = "component", values_to = "years") %>%
    mutate(component = factor(component, levels = c("Dead","UHE","HE"))) %>%
    ggplot(aes(x = years, y = country, fill = component)) +
    geom_col(width = 0.6, position = "stack") +
    geom_vline(xintercept = BUDGET, linetype = "dashed", colour = "black", linewidth = 0.4) +
    facet_wrap(~sex, ncol = 2) +
    scale_fill_manual(
      values = c(HE = COL_HEALTHY, UHE = COL_ULE, Dead = COL_DEAD),
      labels = c(HE = "Healthy life (HLE)", UHE = "Unhealthy life (UHE)",
                 Dead = "Healthy years lost to death"),
      breaks = c("HE","UHE","Dead")
    ) +
    scale_x_continuous(breaks = seq(0, 60, 10), expand = c(0, 0.5)) +
    labs(
      title   = title_str,
      subtitle = "Health dimension: GALI | Method: ",
      x = "Years (age 50 to 110)", y = NULL, fill = NULL,
      caption = "Source: SHARE Wave 7 and HMD."
    ) +
    theme_bw(base_size = 10) +
    theme(
      legend.position    = "bottom",
      legend.key.size    = unit(0.4, "cm"),
      strip.background   = element_rect(fill = "grey92"),
      strip.text         = element_text(face = "bold"),
      panel.grid.major.y = element_blank(),
      plot.title         = element_text(size = 10, face = "bold"),
      plot.subtitle      = element_text(size = 9, colour = "grey40")
    )
}

sel_countries <- c("EST","LVA","LTU","BGR","HUN","POL","PRT","ITA","FRA","DNK","SWE","CHE")

## CAL shares essentially the same country set as Sullivan
cal_stacked_countries <- intersect(sel_countries, cal$country)
figS1 <- make_stacked_fig(
  cal, "CAL", cal_stacked_countries,
  "Figure S1. Lifespan budget decomposition — CAL method (supplementary)"
)

figS1
ggsave(here("figs","Supp","figS1_stacked_CAL.pdf"), figS1, width = 8, height = 5.5, device = cairo_pdf)
ggsave(here("figs","Supp","figS1_stacked_CAL.png"), figS1, width = 8, height = 5.5, dpi = 300)

## Multistate: smaller country set
lng_stacked_countries <- intersect(sel_countries, lng$country)
figS2 <- make_stacked_fig(
  lng, "Multistate", lng_stacked_countries,
  "Figure S2. Lifespan budget decomposition — Multistate method (supplementary)"
)

figS2

ggsave(here("figs","Supp","figS2_stacked_Multistate.pdf"), figS2, width = 8, height = 5.5, device = cairo_pdf)
ggsave(here("figs","Supp","figS2_stacked_Multistate.png"), figS2, width = 8, height = 5.5, dpi = 300)



## ============================================================
## Figure 3 — NHYE paper - I HAD TO CORRECT THIS SO KEPT LIKE THIS.
## Decomposition of the gender gap in NHYE (female minus male)
## into the mortality effect and morbidity effect
##
## KEY CORRECTION:
##   NHYE_gap(f-m) = ULE_gap(f-m) - LE_gap(f-m)
##   Mortality effect = mort_ULE - LE_gap  [NEGATIVE: men die earlier]
##   Morbidity effect = prev_ULE           [POSITIVE: women more morbid]
##
## I needed to get the original files here. Hope it´s right.
##   decompo_sullivan.csv   — original decomp of ULE gap
##   decompo_CAL.csv        — CAL version
##   decompo_long.csv       — multistate version
##   sullivan_both.csv      — for LE gap by country
##   femCAL.csv, maleCAL.csv, femlong.csv, malelong.csv
## ============================================================


## ── Viridis palette (consistent with other figures) ──────────────────────────
VIR <- viridis(7, option = "D")
COL_MORT <- VIR[2]   # blue-purple  — mortality effect (negative)
COL_MORB <- VIR[6]   # yellow-green — morbidity effect (positive)
BUDGET   <- 60

## ── Load data ─────────────────────────────────────────────────────────────────

## LE gap by country (female - male)
le_gap <- sull %>%
  select(country, sex, ex) %>%
  pivot_wider(names_from = sex, values_from = ex) %>%
  mutate(gap_LE = female - male) %>%
  select(country, gap_LE)

## Country-code mapping: decomp files use DEU/FRA, LE data uses DEUTNP/FRATNP
code_map <- c(DEU = "DEUTNP", FRA = "FRATNP")
le_gap <- le_gap %>%
  mutate(country_decomp = case_when(
    country == "DEUTNP" ~ "DEU",
    country == "FRATNP" ~ "FRA",
    TRUE ~ country
  ))

## ── Function: compute correct NHYE decomposition ──────────────────────────────
## mort_NHYE = mort_ULE - LE_gap
## prev_NHYE = prev_ULE  (unchanged)
## total = mort_NHYE + prev_NHYE = NHYE_gap(f-m)  [verified algebraically]

make_nhye_decomp <- function(decomp_file, method_label,
                             le_gap_df, dim_col = "dimension") {
  d <- read.csv(decomp_file)
  if (dim_col != "dimension") d <- rename(d, dimension = !!sym(dim_col))
  
  ## harmonise dimension labels to upper case
  d <- d %>%
    mutate(dimension = toupper(dimension),
           dimension = recode(dimension,
                              "CHR" = "Chronic morbidity",
                              "ADL" = "ADL",
                              "GAL"  = "GALI", 
                              "GALI" = "GALI",
                              "SR"  = "Self-rated health"))
  
  ## join LE gap using decomp country codes
  d <- d %>%
    left_join(le_gap_df %>% select(country_decomp, gap_LE),
              by = c("country" = "country_decomp"))
  
  d %>%
    mutate(
      mort_NHYE  = mort - gap_LE,   # negative → men carry more NHYE
      morb_NHYE  = prev,            # positive → women offset male disadvantage
      total_NHYE = mort_NHYE + morb_NHYE,
      method     = method_label
    )
}

decomp_s  <- make_nhye_decomp(here("data","final_data_files","decompo_sullivan.csv"), "Sullivan", le_gap)
decomp_c  <- make_nhye_decomp(here("data","final_data_files","decompo_CAL.csv"),      "CAL",      le_gap)
decomp_l  <- make_nhye_decomp(here("data","final_data_files","decompo_long.csv"),     "Multistate", le_gap,
                              dim_col = "health")

## ── Main text figure: Sullivan (n = 23), all 4 dimensions ────────────────────
dim_order <- c("ADL", "Chronic morbidity", "GALI", "Self-rated health")

fig3_data <- decomp_s %>%
  filter(!is.na(mort_NHYE)) %>%
  mutate(
    dimension = factor(dimension, levels = dim_order),
    country   = factor(country, levels = rev(sort(unique(country))))
  ) %>%
  pivot_longer(c(mort_NHYE, morb_NHYE),
               names_to = "effect", values_to = "value") %>%
  mutate(
    effect = factor(effect,
                    levels = c("mort_NHYE", "morb_NHYE"),
                    labels = c("Mortality effect", "Morbidity effect"))
  )

fig3 <- ggplot(fig3_data, aes(x = value, y = country, fill = effect)) +
  geom_col(width = 0.6, position = "stack") +
  geom_vline(xintercept = 0, colour = "black", linewidth = 0.4) +
  facet_wrap(~dimension, nrow = 2, scales = "free_x") +
  scale_fill_manual(
    values = c("Mortality effect" = COL_MORT,
               "Morbidity effect" = COL_MORB),
    labels = c(
      "Mortality effect" =
        "Mortality effect (negative: men\u2019s earlier death inflates male NHYE)",
      "Morbidity effect" =
        "Morbidity effect (positive: women\u2019s higher morbidity offsets)"
    )
  ) +
  labs(
    title    = "Figure 3. Decomposition of the gender gap in NHYE (female\u2009\u2212\u2009male)\ninto the mortality and morbidity effects",
    subtitle = paste0("Method: Sullivan (n\u202f=\u202f23 countries). ",
                      "Bars sum to the total NHYE gender gap. ",
                      "Analogous figures for CAL and Multistate: Figures\u00a0S3a\u2013b."),
    x        = "Contribution to NHYE gap (years, female \u2212 male)",
    y        = NULL,
    fill     = NULL,
    caption  = "Age 50, European countries, 2017. Source: SHARE Wave\u202f7 and HMD."
  ) +
  theme_bw(base_size = 10) +
  theme(
    legend.position    = "bottom",
    legend.key.size    = unit(0.4, "cm"),
    panel.grid.major.y = element_blank(),
    strip.background   = element_rect(fill = "grey92"),
    strip.text         = element_text(face = "bold"),
    plot.title         = element_text(size = 10, face = "bold"),
    plot.subtitle      = element_text(size = 9, colour = "grey40")
  )

fig3

ggsave(here("figs","fig3_decomp_bars.pdf"), fig3, width = 8.5, height = 7, device = cairo_pdf)
ggsave(here("figs","fig3_decomp_bars.png"), fig3, width = 8.5, height = 7, dpi = 300)



## ── Supplementary S3a: CAL decomposition ─────────────────────────────────────
figS3a_data <- decomp_c %>%
  filter(!is.na(mort_NHYE)) %>%
  mutate(
    dimension = factor(dimension, levels = dim_order),
    country   = factor(country, levels = rev(sort(unique(country))))
  ) %>%
  pivot_longer(c(mort_NHYE, morb_NHYE),
               names_to = "effect", values_to = "value") %>%
  mutate(effect = factor(effect,
                         levels = c("mort_NHYE","morb_NHYE"),
                         labels = c("Mortality effect","Morbidity effect")))

figS3a <- ggplot(figS3a_data, aes(x = value, y = country, fill = effect)) +
  geom_col(width = 0.6, position = "stack") +
  geom_vline(xintercept = 0, colour = "black", linewidth = 0.4) +
  facet_wrap(~dimension, nrow = 2, scales = "free_x") +
  scale_fill_manual(values = c("Mortality effect" = COL_MORT,
                               "Morbidity effect" = COL_MORB)) +
  labs(
    title    = "Figure S3a. Decomposition of the NHYE gender gap \u2014 CAL method (supplementary)",
    subtitle = "CAL (n\u202f=\u202f22 countries). Mortality effect negative; morbidity effect positive.",
    x        = "Contribution to NHYE gap (years, female \u2212 male)",
    y        = NULL, fill = NULL,
    caption  = "Age 50, European countries, 2017. Source: SHARE Wave\u202f7 and HMD."
  ) +
  theme_bw(base_size = 10) +
  theme(
    legend.position    = "bottom",
    panel.grid.major.y = element_blank(),
    strip.background   = element_rect(fill = "grey92"),
    strip.text         = element_text(face = "bold"),
    plot.title         = element_text(size = 10, face = "bold"),
    plot.subtitle      = element_text(size = 9, colour = "grey40")
  )

figS3a

ggsave(here("figs","Supp", "figS3a_decomp_CAL.pdf"), figS3a, width = 8.5, height = 7, device = cairo_pdf)
ggsave(here("figs","Supp","figS3a_decomp_CAL.png"), figS3a, width = 8.5, height = 7, dpi = 300)



## ── Supplementary S3b: Multistate decomposition ──────────────────────────────



figS3b_data <- decomp_l %>%
  filter(!is.na(mort_NHYE)) %>%
  mutate(
    dimension = factor(dimension, levels = dim_order),
    country   = factor(country, levels = rev(sort(unique(country))))
  ) %>%
  pivot_longer(c(mort_NHYE, morb_NHYE),
               names_to = "effect", values_to = "value") %>%
  mutate(effect = factor(effect,
                         levels = c("mort_NHYE","morb_NHYE"),
                         labels = c("Mortality effect","Morbidity effect")))

figS3b <- ggplot(figS3b_data, aes(x = value, y = country, fill = effect)) +
  geom_col(width = 0.6, position = "stack") +
  geom_vline(xintercept = 0, colour = "black", linewidth = 0.4) +
  facet_wrap(~dimension, nrow = 2, scales = "free_x") +
  scale_fill_manual(values = c("Mortality effect" = COL_MORT,
                               "Morbidity effect" = COL_MORB)) +
  labs(
    title    = "Figure S3b. Decomposition of the NHYE gender gap \u2014 Multistate method (supplementary)",
    subtitle = "Multistate (n\u202f=\u202f13 countries). Mortality effect negative; morbidity effect positive.",
    x        = "Contribution to NHYE gap (years, female \u2212 male)",
    y        = NULL, fill = NULL,
    caption  = "Age 50, European countries, 2015\u20132017. Source: SHARE Waves\u202f6\u20137 and HMD."
  ) +
  theme_bw(base_size = 10) +
  theme(
    legend.position    = "bottom",
    panel.grid.major.y = element_blank(),
    strip.background   = element_rect(fill = "grey92"),
    strip.text         = element_text(face = "bold"),
    plot.title         = element_text(size = 10, face = "bold"),
    plot.subtitle      = element_text(size = 9, colour = "grey40")
  )

figS3b

ggsave(here("figs","Supp","figS3b_decomp_Multistate.pdf"), figS3b, width = 8.5, height = 7, device = cairo_pdf)
ggsave(here("figs","Supp","figS3b_decomp_Multistate.png"), figS3b, width = 8.5, height = 7, dpi = 300)

## ─────────────────────────────────────────────────────────────────────────────
## FIGURE S4: LE gap vs NHLE gap (tests whether mortality gap drives reversal)
##   X: female minus male LE at 50 | Y: female minus male NHLE
##   One panel per dimension, Sullivan only just because it´s easier to see
## ─────────────────────────────────────────────────────────────────────────────

fig4_data <- gaps %>%
  filter(method == "Sullivan") %>%
  pivot_longer(
    cols      = c(gNHLE_ADL, gNHLE_CHR, gNHLE_GALI, gNHLE_SR),
    names_to  = "dimension", values_to = "gNHLE",
    names_prefix = "gNHLE_"
  ) %>%
  mutate(
    dimension = factor(dimension,
                       levels = c("ADL","CHR","GALI","SR"),
                       labels = c("ADL","Chronic morbidity","GALI","Self-rated health")),
    label = ifelse(country %in% label_countries, country, NA_character_)
  )

## Per-panel Pearson r — placed in upper-right corner of each facet
fig4_cors <- fig4_data %>%
  group_by(dimension) %>%
  summarise(
    r     = cor(gap_LE, gNHLE, use = "complete.obs"),
    label = sprintf("r = %.2f", r),
    ## position: just inside panel edges (using Inf/-Inf with hjust/vjust)
    x = Inf, y = Inf,
    .groups = "drop"
  )

figS4 <- ggplot(fig4_data, aes(x = gap_LE, y = gNHLE)) +
  geom_hline(yintercept = 0, colour = "black", linewidth = 0.4) +
  geom_smooth(method = "lm", se = TRUE, colour = VIR[6], fill = VIR[6],
              linewidth = 0.8, alpha = 0.3) +
  geom_point(colour = VIR[2], size = 2, alpha = 0.85) +
  ## r annotation — top-right of each panel
  geom_text(
    data = fig4_cors, aes(x = x, y = y, label = label),
    hjust = 1.15, vjust = 1.6, size = 3, colour = "grey30",
    fontface = "italic", inherit.aes = FALSE
  ) +
  ## country labels (NA rows silently dropped with na.rm = TRUE)
  ggrepel::geom_text_repel(
    aes(label = label), size = 2.5, colour = "grey25",
    min.segment.length = 0.2, max.overlaps = 15,
    box.padding = 0.3, na.rm = TRUE, show.legend = FALSE
  ) +
  facet_wrap(~dimension, nrow = 2, scales = "free_y") +
  labs(
    title    = "Figure 4. Life expectancy gap versus NHLE gap (female\u2009\u2212\u2009male)",
    subtitle = "For ADL and GALI, larger male mortality disadvantage predicts a larger female NHLE advantage (negative slope);\nfor chronic morbidity and self-rated health, high female morbidity prevalence offsets the mortality effect",
    x        = "Gender gap in life expectancy at 50 (years)",
    y        = "Gender gap in NHLE (years, female \u2212 male)",
    caption  = "Method: Sullivan. Source: SHARE Wave 7 and HMD period life tables, 2017."
  ) +
  theme_bw(base_size = 10) +
  theme(
    strip.background = element_rect(fill = "grey92"),
    strip.text       = element_text(face = "bold"),
    plot.title       = element_text(size = 10, face = "bold"),
    plot.subtitle    = element_text(size = 9, colour = "grey40"),
    plot.subtitle.position = "plot"
  )

figS4
ggsave(here("figs","Supp","figS4_le_gap_vs_nhle_gap.pdf"), figS4, width = 8, height = 6.5, device = cairo_pdf)
ggsave(here("figs","Supp","figS4_le_gap_vs_nhle_gap.png"), figS4, width = 8, height = 6.5, dpi = 300)


## ─────────────────────────────────────────────────────────────────────────────
## FIGURE 5 (Supplementary): Method comparison — NHLE gaps Sullivan vs CAL
##   and Sullivan vs Multistate, confirming method robustness
## ─────────────────────────────────────────────────────────────────────────────

## Build wide format: one row per country × dimension
make_method_wide <- function(gaps_df, m1, m2, dim) {
  g1 <- gaps_df %>% filter(method == m1) %>%
    select(country, val = paste0("gNHLE_", dim)) %>% rename(!!m1 := val)
  g2 <- gaps_df %>% filter(method == m2) %>%
    select(country, val = paste0("gNHLE_", dim)) %>% rename(!!m2 := val)
  inner_join(g1, g2, by = "country") %>%
    mutate(dimension = factor(dim, levels=c("ADL","CHR","GALI","SR"),
                              labels=c("ADL","Chronic morbidity","GALI","Self-rated health")))
}

fig5a_data <- bind_rows(lapply(c("ADL","CHR","GALI","SR"),
                               function(d) make_method_wide(gaps, "Sullivan","CAL",d)))
fig5b_data <- bind_rows(lapply(c("ADL","CHR","GALI","SR"),
                               function(d) make_method_wide(gaps, "Sullivan","Multistate",d)))

## Compute per-panel correlation for annotation
cors_a <- fig5a_data %>% group_by(dimension) %>%
  summarise(r = cor(Sullivan, CAL, use="complete.obs"),
            x = -Inf, y = Inf, .groups="drop")
cors_b <- fig5b_data %>% group_by(dimension) %>%
  summarise(r = cor(Sullivan, Multistate, use="complete.obs"),
            x = -Inf, y = Inf, .groups="drop")

p5a <- ggplot(fig5a_data, aes(x = Sullivan, y = CAL)) +
  geom_abline(slope=1, intercept=0, linetype="dashed", colour="grey60") +
  geom_point(colour = VIR[2], size=2, alpha=0.85) +
  geom_text(data=cors_a, aes(x=x, y=y, label=sprintf("r=%.5f",r)),
            hjust=-0.1, vjust=1.4, size=3, colour=VIR[6]) +
  facet_wrap(~dimension, nrow=2, scales="free") +
  labs(title="Sullivan vs CAL", x="NHYE gap — Sullivan", y="NHYE gap — CAL") +
  theme_bw(base_size=9) +
  theme(strip.background=element_rect(fill="grey92"), strip.text=element_text(face="bold"),
        plot.title=element_text(size=9, face="bold"))

p5b <- ggplot(fig5b_data, aes(x = Sullivan, y = Multistate)) +
  geom_abline(slope=1, intercept=0, linetype="dashed", colour="grey60") +
  geom_point(colour = VIR[2], size=2, alpha=0.85) +
  geom_text(data=cors_b, aes(x=x, y=y, label=sprintf("r=%.4f",r)),
            hjust=-0.1, vjust=1.4, size=3, colour=VIR[5]) +
  facet_wrap(~dimension, nrow=2, scales="free") +
  labs(title="Sullivan vs Multistate", x="NHYE gap — Sullivan", y="NHYE gap — Multistate") +
  theme_bw(base_size=9) +
  theme(strip.background=element_rect(fill="grey92"), strip.text=element_text(face="bold"),
        plot.title=element_text(size=9, face="bold"))

figS5 <- p5a + p5b +
  plot_annotation(
    title    = "Figure 5 (Supplementary). Gender gap in NHYE: method comparison",
    subtitle = "Diagonal line = perfect agreement. r = Pearson correlation between country-level NHYE gaps across methods.\nSullivan vs CAL: r >= 0.997 for all dimensions (same prevalence data; period vs cohort survivorship barely differs).\nSullivan vs Multistate: r = 0.40-0.92 (different prevalence estimation method). Gender gap = female minus male, age 50.",
    caption  = "Source: SHARE Waves 6-7 and HMD, 2017.",
    theme    = theme(plot.title    = element_text(size=10, face="bold"),
                     plot.subtitle = element_text(size=8, colour="grey40"))
  )

figS5
ggsave(here("figs","Supp","figS5_method_comparison.pdf"), figS5, width=10, height=7, device=cairo_pdf)
ggsave(here("figs","Supp","figS5_method_comparison.png"), figS5, width=10, height=7, dpi=300)




