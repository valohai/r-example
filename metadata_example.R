
# it is a bit more efficient to install packages in your Docker image though
if (length(find.package("jsonlite", quiet=TRUE)) <= 0) {
  install.packages("jsonlite", repos="http://cran.r-project.org")
}

library(jsonlite)

args = commandArgs(trailingOnly=TRUE)

if (length(args) != 2) {
  stop("You must provide exactly two parameters (max epoch, loss decrement).\n", call.=FALSE)
}

maxEpochs <- as.integer(args[1])
if (maxEpochs < 1) {
  stop("Max epoch (first parameter) cannot be less than one.\n", call.=FALSE)
}

lossDecrement <- as.double(args[2])
if (lossDecrement <= 0) {
  stop("Loss decrement (second parameter) cannot be or be less than zero.\n", call.=FALSE)
}
loss <- 1

for (epoch in 1:maxEpochs) {
  Sys.sleep(0.25)
  metadataEvent <- list()
  metadataEvent[["epoch"]] <- epoch
  metadataEvent[["loss"]] <- loss
  if (epoch == ceiling(maxEpochs / 2)) {
    metadataEvent[["half-loss"]] <- loss
  }
  write(toJSON(metadataEvent, auto_unbox=TRUE), stdout())
  loss <- max(0.0, (loss - lossDecrement))
}
