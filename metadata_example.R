args = commandArgs(trailingOnly=TRUE)

if (length(args) != 2) {
  stop("You must provide exactly two parameters (max epoch, loss decrement).\n", call.=FALSE)
}

maxEpochs <- args[1]
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
  metadata <- paste('{"epoch": ', epoch, ', "loss": ', loss, '}', sep = '')
  write(metadata, stdout())
  loss <- max(0.0, (loss - lossDecrement))
}
