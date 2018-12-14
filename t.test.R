# Load the data from file:
datasets <- c('a', 'b')

weights <- list()
for(d in datasets){
    filename <- paste('newts/location-', d, '.txt', sep='')
    weights[[d]] <- as.numeric(readLines(filename))
}




# Big data analysis:

# read in the raw annotations:
raw.annot <- read.table('E-GEOD-35211/A-MEXP-1171.adf', sep='\t', header=TRUE, row.names=1, skip=18)
annot <- d[i, c('Reporter.Database.Entry.entrez.', 'Reporter.Database.Entry.hugo.', 'Reporter.Sequence')]
colnames(annot) <- c('ENTREZ', 'symbol', 'sequence')
annot[annot$symbol == '', 'symbol'] <- '(unannotated)'

# Read in the sample metadata:
metadata.raw <- read.table('E-GEOD-35211/E-GEOD-35211.sdrf', sep='\t', header=TRUE, row.names=1)
metadata <- data.frame(
    celltype = as.factor(gsub('([^ -]+).*', '\\1', metadata.raw[['Characteristics..cell.type.']], perl=TRUE)),
    treatment = factor('control', levels=c('control', 'HIP1')),
    row.names = gsub(' 1', '', rownames(metadata.raw))
)
metadata[grep('HIP1', metadata.raw[['Comment..Sample_source_name.']]), 'treatment'] <- 'HIP1'

# Read in the raw files:
exprs <- list()
for(sample in rownames(metadata)){
    filename <- paste('E-GEOD-35211/processed/', sample, '_sample_table.txt', sep='')
    exprs[[sample]] <- read.table(filename, sep='\t', header=TRUE, row.names=1)
}
exprs <- as.matrix(cbind.data.frame(exprs))
colnames(exprs) <- rownames(metadata)

# Continue...