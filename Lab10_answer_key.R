date()
Sys.info()
ans_key_lab10 <- list( list(name="babies_born_by_decade_and_sex",hash="0a205d3169bcea05112d323cdf78b35a"),
                       list(name="babies_born_by_name_and_sex",hash="b45c1e86116f7ba06ca9d753d682d123"),
                       list(name="sex_ratio_by_decade",hash="2cc92e401856fc760cc26e186cfbaadc"),
                       list(name="mean_rank_by_name_and_sex",hash="ce8ce77a278eccc5a92428fae161d03c"),
                       list(name="baby_letters_rel",hash="4d01e48133f7d3ff0d97941a164993a3"))

test <- function(x,i){
    points <- 0
    cat(paste0("Test ",i,":\n"))
    cat(paste0("Is the variable \"",x$name,"\" defined? ",ifelse(exists(x$name),"YES.","NO."),"\n"))
    if (exists(x$name)) {
        cat(paste0("Testing the value of ",x$name,": ",ifelse(digest::digest(get(x$name))==x$hash,"CORRECT","INCORRECT")),"\n")
        points <- 6
        cat("Printing first few rows...\n")
        print(head(get(x$name)))
        cat("\n\n")
    }
    else {
      cat("\t Skipping...\n\n")
    }
    points
}

i <- 1
pointsearned <- 0
maxpoints <- 30
for (item in ans_key_lab10) {
  points <- test(item,i)
  pointsearned <- pointsearned + points
  i <- i + 1  
}

cat(paste0("\nEarned: ",pointsearned," points out of ",maxpoints," possible.\n"))