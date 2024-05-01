exit_val <- 0

args <- commandArgs(trailingOnly = TRUE)

cat(
  "-----------------------------------------------",
  "Loading R data file in quarantined environment…",
  "-----------------------------------------------",
  "",
  sep = "\n"
)

quarantine <- new.env(parent = emptyenv())

load(args[1], envir = quarantine, verbose = TRUE)

cat(
  "",
  "-----------------------------------------",
  "Enumerating objects in loaded R data file",
  "-----------------------------------------",
  "",
  sep = "\n"
)

print(
  ls.str(quarantine, all.names = TRUE),
  max.level = 999,
  give.attr = TRUE
)

c(
  ".Last",
  ".Last.sys",
  "quit",
  "print",
  "q"
) -> dangerous_functions

funs <- lsf.str(quarantine, all.names = TRUE)

if (length(funs) > 0) {
  cat(
    "",
    "------------------------------------",
    "Functions found: enumerating sources",
    "------------------------------------",
    "",
    sep = "\n"
  )

  for (fun in funs) {
    cat("Checking `", fun, "`…\n", sep = "")

    if (fun %in% dangerous_functions) {
      exit_val <- 1
      cat("\n!! `", fun, "` may execute arbitrary code on your system under certain conditions !!\n", sep = "")
    }

    cat("\n`", fun, "` source:\n", sep = "")

    print(body(quarantine[[fun]]))

    cat("", "", sep = "\n")
  }
}

quit(save = "no", status = exit_val, runLast = FALSE)
