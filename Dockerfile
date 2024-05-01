FROM r-base:latest

COPY check.R .

CMD [ "Rscript", "check.R", "/unsafe.rda"]
