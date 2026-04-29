# load in methylation data
# contains 2 datasets: 'beta_mat' and 'pheno_post_samp_qc'
load("S_Afr_beta_pheno_cellprops.RData")

#load nctb dataset
nctb <- read.delim("nctb_truncated", sep = ",")

#change names in "record_id" column of 'nctb' to match "Sample_Name" in 'pheno_post_samp_qc' dataset
nctb$NC_id <- paste0("NC", nctb$record_id)

#filter 'pheno_post_samp_qc' dataset with "Sample_Name"s that only overlap with NC_id in nctb dataset
nctb_meth_pheno <- pheno_post_samp_qc[pheno_post_samp_qc$Sample_Name %in% nctb$NC_id, ]

#create vector that contains overlapping colnames in 'beta_mat' and rownames in 'nctb_meth_pheno' 
to_keep <- colnames(beta_mat)[colnames(beta_mat) %in% rownames(nctb_meth_pheno)]

#create a new dataframe with overlapping columns and rows
nctb_beta <- beta_mat[,colnames(beta_mat) %in% to_keep]

#rename colnames of 'beta_mat' with "Sample_Name" in 'nctb_meth_pheno'
names <- setNames(nctb_meth_pheno[[1]], rownames(nctb_meth_pheno))
colnames(nctb_beta) <- names[colnames(nctb_beta)]

#merge "nctb_meth_pheno" and "nctb" into one dataframe
nctb_meth_pheno$NC_id <- nctb_meth_pheno$Sample_Name
nctb_merged <- merge(nctb, nctb_meth_pheno, by = "NC_id")
write.csv(nctb_merged, "nctb_merged.csv", row.names = FALSE)
