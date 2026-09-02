clean_captions <- function(tbl) {
  
  captions <- c(
    "OPENING TITLES: THE ROOKIE",
    "NINE MONTHS LATER",
    "TWO WEEKS LATER",
    "\"ONE MONTH LATER\"",
    "\"DAY 2\"",
    "\"DAY 4\"",
    "97 MINUTES EARLIER",
    "6 WEEKS LATER",
    "12 HOURS EARLIER",
    "EMERGENCY ALERT",
    "BALLISTIC MISSILE THREAT",
    "INBOUND TO LOS ANGELES",
    "SEEK IMMEDIATE SHELTER",
    "IMPACT IN 29 MINUTES",
    "THIS IS NOT A DRILL",
    "IN TRAILER",
    "DETECTIVES' BULLPEN",
    "THREE MONTHS LATER"
  )
  
  tbl |> 
    mutate(
      type = type |> replace_when(
        transcript %in% captions                                    ~ "caption",
        str_detect(transcript, "TO\\sBE\\sCONTINUED[\\.{3}|\u2026]") ~ "caption"
      )
    )
  
}
