### Unit tests for methodsEmap.R functions

library(enrichViewNet)

data(demoGOST)



### Tests createEnrichMap() results

context("createEnrichMap() results")

test_that("createEnrichMap() must return error when gostObject is a number", {
    
    error_message <- paste0("The gostObject object should be a list ", 
                        "with meta and result as entries corresponding ", 
                        "to gprofiler2 enrichment output.")
    
    expect_error(createEnrichMap(gostObject=33, query="TEST", 
        source="GO:CC", termIDs=NULL, removeRoot=TRUE,
        showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=FALSE), error_message)
})


test_that("createEnrichMap() must return error when gostObject is a string character", {
    
    error_message <- paste0("The gostObject object should be a list ", 
                        "with meta and result as entries corresponding ", 
                        "to gprofiler2 enrichment output.")
    
    expect_error(createEnrichMap(gostObject="TEST", query="TEST", 
        source="GO:CC", termIDs=NULL, removeRoot=TRUE, 
        showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=FALSE), error_message)
})


test_that("createEnrichMap() must return error when query is a number", {
    
    gostObject <- list()
    gostObject[["meta"]] <- list()
    gostObject[["result"]] <- list()
    
    error_message <- paste0("The \'query\'must be a character string.")
    
    expect_error(createEnrichMap(gostObject=gostObject, query=33, 
        source="KEGG", termIDs=NULL, removeRoot=TRUE, 
        showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=FALSE), error_message)
})


test_that("createEnrichMap() must return error when query is a vector of strings", {
    
    gostObject <- list()
    gostObject[["meta"]] <- list()
    gostObject[["result"]] <- list()
    
    error_message <- paste0("The \'query\'must be a character string.")
    
    expect_error(createEnrichMap(gostObject=gostObject, query=c("1", "2"), 
        source="KEGG", termIDs=NULL, removeRoot=TRUE, 
        showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=FALSE), error_message)
})


test_that("createEnrichMap() must return error when query is not in gost", {
  
    error_message <- paste0("The \'query\' is not present in the ", 
                                    "results of the gost object.")
    
    expect_error(createEnrichMap(gostObject=demoGOST, query="CANADA", 
        source="KEGG", termIDs=NULL, removeRoot=TRUE,
        showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=FALSE), error_message)
})


test_that("createEnrichMap() must return error when source is a number", {
    
    gostObject <- list()
    gostObject[["meta"]] <- list()
    gostObject[["result"]] <- list()
    
    error_message <- paste0("Assertion on 'arg' failed: Must be of type ", 
                                "'character', not 'double'.")
    
    expect_error(createEnrichMap(gostObject=gostObject, query="toto", 
        source=333, termIDs=NULL, removeRoot=TRUE, 
        showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=FALSE),  error_message)
})

test_that("createEnrichMap() must return error when source is a wrong name", {
    
    gostObject <- list()
    gostObject[["meta"]] <- list()
    gostObject[["result"]] <- list()
    
    expect_error(createEnrichMap(gostObject=gostObject, query="toto",  
        source="test", termIDs=NULL, removeRoot=TRUE, title="network", 
        showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=FALSE))
})


test_that("createEnrichMap() must return error when source is GO", {
    
    gostObject <- list()
    gostObject[["meta"]] <- list()
    gostObject[["result"]] <- list()
    
    expect_error(createEnrichMap(gostObject=gostObject, query="toto", 
        source="GO",
        termIDs=NULL, removeRoot=TRUE, 
        showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=FALSE))
})


test_that("createEnrichMap() must return error when removeRoot remove last enriched term", {
    
    gostTerm <- demoGOST
    gostTerm$result <- demoGOST$result[54,]
    
    error_message <- paste0("With removal of the root term, there is no ", 
                                "enrichment term left")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
                    source="WP", removeRoot=TRUE, 
                    showCategory=30, groupCategory=FALSE, categoryLabel=1,
                    categoryNode=1, line=1, force=FALSE), error_message)
})


test_that("createEnrichMap() must return error when removeRoot remove last enriched term from term list", {
    
    gostTerm <- demoGOST
    gostTerm$result <- demoGOST$result[54,]
    
    error_message <- paste0("With removal of the root term, there is no ", 
                                "enrichment term left")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
        source="TERM_ID",
        termIDs=c("WP:000000"), removeRoot=TRUE, showCategory=30, 
        groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=FALSE), error_message)
})


test_that("createEnrichMap() must return error when showCategory negative value", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The \'showCategory\' parameter must an positive ", 
            "integer or a vector of character strings representing terms.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
                    source="WP", removeRoot=TRUE, showCategory=-30, 
                    groupCategory=FALSE, categoryLabel=1,
                    categoryNode=1, line=2, force=FALSE), error_message)
})


test_that("createEnrichMap() must return error when showCategory is boolean", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The \'showCategory\' parameter must an positive ", 
            "integer or a vector of character strings representing terms.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
                    source="WP", removeRoot=TRUE, showCategory=TRUE, 
                    groupCategory=FALSE, categoryLabel=1,
                    categoryNode=1, line=1, force=TRUE), error_message)
})


test_that("createEnrichMap() must return error when groupCategory is integer", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The \'groupCategory\' parameter must a logical ", 
                                "(TRUE or FALSE).")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
            source="WP", removeRoot=TRUE, showCategory=30, 
            groupCategory=22, categoryLabel=1,
            categoryNode=1, line=1, force=TRUE), error_message, fixed=TRUE)
})


test_that("createEnrichMap() must return error when categoryLabel is string", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The \'categoryLabel\' parameter ", 
                                "must be a positive numeric.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
            source="WP", removeRoot=TRUE, showCategory=30, 
            groupCategory=FALSE, categoryLabel="test",
            categoryNode=1, line=2, force=TRUE), error_message, fixed=TRUE)
})


test_that("createEnrichMap() must return error when cexLabelCategory is negative", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The \'categoryLabel\' parameter ", 
                                "must be a positive numeric.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
            source="WP", removeRoot=TRUE, showCategory=30, 
            groupCategory=FALSE, categoryLabel=-1.1,
            categoryNode=1, line=2, force=TRUE), error_message, fixed=TRUE)
})


test_that("createEnrichMap() must return error when categoryNode is negative", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The \'categoryNode\' parameter ", 
                                "must be a positive numeric.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
                    source="WP", removeRoot=TRUE, showCategory=30, 
                    groupCategory=FALSE, categoryLabel=2,
                    categoryNode=-1), error_message, fixed=TRUE)
})


test_that("createEnrichMap() must return error when categoryNode is string", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The \'categoryNode\' parameter ", 
                                "must be a positive numeric.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
            source="WP", removeRoot=TRUE, showCategory=30, 
            groupCategory=FALSE, categoryLabel=2,
            categoryNode="te", line=1, force=FALSE), error_message, fixed=TRUE)
})

test_that("createEnrichMap() must return error when line is a string", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The \'line\' parameter must be a ", 
                                "positive numeric.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
        source="WP", removeRoot=TRUE,  showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, line="HI", force=TRUE), 
        error_message, fixed=TRUE)
})

test_that("createEnrichMap() must return error when line is a negative number", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The \'line\' parameter must be a ", 
                                "positive numeric.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
        source="WP", removeRoot=TRUE,  showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, line=-0.3, force=TRUE), 
        error_message, fixed=TRUE)
})

test_that("createEnrichMap() must return error when force is a string", {

    gostTerm <- demoGOST
    
    error_message <- paste0("The \'force\' parameter must a logical ", 
                                "(TRUE or FALSE).")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
        source="WP", removeRoot=TRUE,  showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, line=1, force="TOTO"), error_message, 
        fixed=TRUE)
})

test_that("createEnrichMap() must return error when not term for selected source", {
    
    gostTerm <- demoGOST
    gostTerm$result <- gostTerm$result[gostTerm$result$source != "WP", ]
    
    error_message <- paste0("There is no enriched term for the selected ", 
                                "source \'WP'.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
        source="WP", removeRoot=TRUE,  showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, line=1, force=TRUE), error_message, 
                 fixed=TRUE)
})

test_that("createEnrichMap() must return error when not term id and TERM_ID selected", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("A vector of terms should be given through the ",
                        "\'termIDs\' parameter when source is \'TERM_ID\'.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
        source="TERM_ID", removeRoot=TRUE,  showCategory=30, 
        groupCategory=FALSE, categoryLabel=1, categoryNode=1, line=1, 
        force=TRUE), error_message, fixed=TRUE)
})

test_that("createEnrichMap() must return error when not all term ids are present", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("Not all listed terms are present in the  ",
                                    "enrichment results.")
    
    expect_error(createEnrichMap(gostObject=gostTerm, query="query_1", 
        source="TERM_ID", termIDs = c("GO:0051173", "GO:0065004", "GO:1905898"), 
        removeRoot=TRUE,  showCategory=30, 
        groupCategory=FALSE, categoryLabel=1, categoryNode=1, line=1, 
        force=TRUE), error_message, fixed=TRUE)
})


### Tests createEnrichMapMultiBasic() results

context("createEnrichMapMultiBasic() results")

test_that("createEnrichMapMultiBasic() must return error when gostObjectList is a number", {
    
    error_message <- paste0("The gostObjectList object should be a list ", 
        "of enrichment objects. At least 2 enrichment objects are required.")
    
    expect_error(createEnrichMapMultiBasic(gostObjectList=33, 
        queryList=c("TEST", "Test2"),  source="GO:CC", termIDs=NULL, 
        removeRoot=TRUE, showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiBasic() must return error when gostObjectList has only one element", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The gostObjectList object should be a list ", 
        "of enrichment objects. At least 2 enrichment objects are required.")
    
    expect_error(createEnrichMapMultiBasic(gostObjectList=list(gostTerm), 
        queryList=list("TEST"), source="GO:CC", termIDs=NULL, removeRoot=TRUE, 
        showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiBasic() must return error when queryList is a number", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The queryList object should be a list of query ", 
        "names. At least 2 query names are required. The number of query ", 
        "names should correspond to the number of enrichment objects.")
    
    expect_error(createEnrichMapMultiBasic(gostObjectList=list(gostTerm, gostTerm), 
        queryList=33, source="GO:CC", termIDs=NULL, removeRoot=TRUE, 
        showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiBasic() must return error when queryList is longer than gostObjectList", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The queryList object should be a list of query ", 
        "names. At least 2 query names are required. The number of query ", 
        "names should correspond to the number of enrichment objects.")
    
    expect_error(createEnrichMapMultiBasic(gostObjectList=list(gostTerm, gostTerm), 
    queryList=list("TEST", "TEST2", "TEST3"), source="GO:CC", termIDs=NULL, 
    removeRoot=TRUE, showCategory=30, groupCategory=FALSE, categoryLabel=1,
    categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiBasic() must return error when one query in queryList is not in gostObject", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("Each query name present in the ", 
        "\'queryList\' parameter must be present in the associated ", 
        "enrichment object.")
    
    expect_error(createEnrichMapMultiBasic(gostObjectList=list(gostTerm, gostTerm), 
        queryList=list("query_1", "TEST"), source="GO:CC", termIDs=NULL, 
        removeRoot=TRUE, showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, force=FALSE), error_message, fixed=TRUE)
})

test_that("createEnrichMapMultiBasic() must return error when one object in gostObjectList in a number", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The gostObjectList should only contain a list ", 
        "of enrichment results. Enrichment results are lists with meta ", 
        "and result as entries corresponding to gprofiler2 ", 
        "enrichment output.")
    
    expect_error(createEnrichMapMultiBasic(gostObjectList=list(gostTerm, 33), 
        queryList=list("query_1", "query_1"), source="GO:CC", termIDs=NULL, 
        removeRoot=TRUE, showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, force=FALSE), error_message, fixed=TRUE)
})

test_that("createEnrichMapMultiBasic() must return error when no enriched term for selected source", {
    
    gostTerm <- demoGOST
    gostTerm$result <- gostTerm$result[which(gostTerm$result$source != "WP"), ]
    
    error_message <- paste0("There is no enriched term for the selected ", 
                                "source \'WP\'.")   
    
    expect_error(createEnrichMapMultiBasic(gostObjectList=list(gostTerm, gostTerm), 
        queryList=list("query_1", "query_1"), source="WP", termIDs=NULL, 
        removeRoot=TRUE, showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, force=FALSE), error_message, fixed=TRUE)
})

test_that("createEnrichMapMultiBasic() must return error when number in queryList", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The queryList object should only contain a list ", 
                                "of query names in character strings.")
    
    expect_error(createEnrichMapMultiBasic(gostObjectList=list(gostTerm, gostTerm), 
        queryList=list("query_1", 33), source="WP", termIDs=NULL, 
        removeRoot=TRUE, showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, force=FALSE), error_message, fixed=TRUE)
})

test_that("createEnrichMapMultiBasic() must return error when number in queryList", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("A vector of terms should be given through the ",
                "\'termIDs\' parameter when source is \'TERM_ID\'.")
    
    expect_error(createEnrichMapMultiBasic(gostObjectList=list(gostTerm, gostTerm), 
        queryList=list("query_1", "query_1"), source="TERM_ID", termIDs=NULL, 
        removeRoot=TRUE, showCategory=30, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, force=FALSE), error_message, fixed=TRUE)
})


### Tests createEnrichMapMultiComplex() results

context("createEnrichMapMultiComplex() results")

test_that("createEnrichMapMultiComplex() must return error when gostObjectList is a number", {
    
    error_message <- paste0("The gostObjectList object should be a list ", 
        "of enrichment objects. At least 2 enrichment objects are required.")
    
    queryDF <- data.frame(queryName=c("parental_napa_vs_DMSO", 
        "rosa_napa_vs_DMSO", "rosa_napa_vs_DMSO"), 
        source=c("GO:CC", "REAC", "GO:CC"), removeRoot=c(TRUE, TRUE, TRUE),
        termIDs=c("", "", ""), stringsAsFactors=FALSE)
    
    expect_error(createEnrichMapMultiComplex(gostObjectList=33, 
        queryInfo=queryDF,  showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, line=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiComplex() must return error when gostObjectList has only one element", {
    
    gostTerm <- demoGOST
    
    queryDF <- data.frame(queryName=c("query_1"), 
            source=c("GO:CC"), removeRoot=c(TRUE),
            termIDs=c(""), stringsAsFactors=FALSE)
    
    error_message <- paste0("The gostObjectList object should be a list ", 
        "of enrichment objects. At least 2 enrichment objects are required.")
    
    expect_error(createEnrichMapMultiComplex(gostObjectList=list(gostTerm), 
        queryInfo=queryDF, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiComplex() must return error when gostObjectList is a list of numbers", {
    
    error_message <- paste0("The gostObjectList should only contain a list ", 
        "of enrichment results. Enrichment results are lists with meta and", 
        " result as entries corresponding to gprofiler2 enrichment", 
        " output.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(3, 4), 
        queryInfo=33, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiComplex() must return error when queryInfo is a number", {
    
    gostTerm <- demoGOST
    
    error_message <- paste0("The queryInfo should a data.frame with ", 
            "those columns: queryName, source, removeRoot and termIDs.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=33, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiComplex() must return error when queryInfo shorter than gostObjectList", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1"), 
        source=c("KEGG"), removeRoot=c(TRUE), termIDs=c(""), 
        stringsAsFactors=FALSE)
        
    error_message <- paste0("The number of rows in queryInfo should ", 
        " correspond to the number of enrichment objects.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiComplex() must return error when source in queryInfo is not in list of sources", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1", "query_1"), 
        source=c("KEGG", "TEST"), removeRoot=c(TRUE, TRUE), termIDs=c("", ""), 
        stringsAsFactors=FALSE)
    
    error_message <- paste0("The values in the \'source\' column of the \'queryInfo\' ", 
        "data frame should be one of those: \"TERM_ID\", \"GO:MF\", ", 
        "\"GO:CC\", \"GO:BP\", \"KEGG\", \"REAC\", \"TF\", ",
        "\"MIRNA\", \"HPA\", \"CORUM\", \"HP\", \"WP\".")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiComplex() must return error when source in queryInfo is number", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1", "query_1"), 
        source=c(33, 22), removeRoot=c(TRUE, TRUE), termIDs=c("", ""), 
        stringsAsFactors=FALSE)
    
    error_message <- paste0("The \'source'\ column of the \'queryInfo\' ", 
        "data frame should be in a character string format.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiComplex() must return error when queryName in queryInfo is number", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c(22, 33), 
        source=c("KEGG", "REAC"), removeRoot=c(TRUE, TRUE), termIDs=c("", ""), 
        stringsAsFactors=FALSE)
    
    error_message <- paste0("The \'queryName'\ column of the \'queryInfo\' ", 
                    "data frame should be in a character string format.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiComplex() must return error when termIDs in queryInfo is number", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1", "query_1"), 
        source=c("KEGG", "REAC"), removeRoot=c(TRUE, TRUE), termIDs=c(33, 22), 
        stringsAsFactors=FALSE)
    
    error_message <- paste0("The \'termIDs'\ column of the \'queryInfo\' ", 
    "data frame should be in a character string format.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message)
})

test_that("createEnrichMapMultiComplex() must return error when removeRoot in queryInfo is number", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1", "query_1"), 
        source=c("KEGG", "REAC"), removeRoot=c(33, 22), termIDs=c("", ""), 
        stringsAsFactors=FALSE)
    
    error_message <- paste0("The \'removeRoot'\ column of the \'queryInfo\' ", 
        "data frame should only contain logical values (TRUE or FALSE).")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message, fixed=TRUE)
})

test_that("createEnrichMapMultiComplex() must return error when query name in queryInfo not in enrichment object", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1", "query_2"), 
        source=c("KEGG", "REAC"), removeRoot=c(TRUE, TRUE), termIDs=c("", ""), 
        stringsAsFactors=FALSE)
    
    error_message <- paste0("Each query name present in the \'queryName'\ ", 
        "column of the \'queryInfo\' data frame must be present in the ", 
        "associated enrichment object.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message, fixed=TRUE)
})

test_that("createEnrichMapMultiComplex() must return error when TERM_ID in queryInfo but not term ids", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1", "query_1"), 
        source=c("KEGG", "TERM_ID"), removeRoot=c(TRUE, TRUE), termIDs=c("", ""), 
        stringsAsFactors=FALSE)
    
    error_message <- paste0("A string of terms should be present in the ",
        "\'termIDs\' column when source is \'TERM_ID\'.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message, fixed=TRUE)
})

test_that("createEnrichMapMultiComplex() must return error when termIDs column in queryInfo contains numbers", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1", "query_1"), 
        source=c("KEGG", "TERM_ID"), removeRoot=c(TRUE, TRUE), termIDs=c(33, 22), 
        stringsAsFactors=FALSE)
    
    error_message <- paste0("The \'termIDs\' column of the 'queryInfo' data ", 
        "frame should be in a character string format.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message, 
        fixed=TRUE)
})

test_that("createEnrichMapMultiComplex() must return error when removeRoot column in queryInfo contains numbers", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1", "query_1"), 
        source=c("KEGG", "TERM_ID"), removeRoot=c(33, 22), termIDs=c("", ""), 
        stringsAsFactors=FALSE)
    
    error_message <- paste0("The \'removeRoot\' column of the 'queryInfo' ", 
        "data frame should only contain logical values (TRUE or FALSE).")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message, 
        fixed=TRUE)
})

test_that("createEnrichMapMultiComplex() must return error when groupName column in queryInfo contains numbers", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1", "query_1"), 
        source=c("KEGG", "REAC"), removeRoot=c(TRUE, TRUE), 
        termIDs=c("", ""), groupName=c(22, 33),  
        stringsAsFactors=FALSE)
    
    error_message <- paste0("The \'groupName\' column of the 'queryInfo' ", 
        "data frame should be in a character string format.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message, 
        fixed=TRUE)
})

test_that("createEnrichMapMultiComplex() must return error when groupName column contain identical names", {
    
    gostTerm <- demoGOST
    
    queryDataFrame <- data.frame(queryName=c("query_1", "query_1"), 
        source=c("KEGG", "REAC"), removeRoot=c(TRUE, TRUE), 
        termIDs=c("", ""), groupName=c("REAC", "REAC"),  
        stringsAsFactors=FALSE)
    
    error_message <- paste0("The \'groupName\' column of the 'queryInfo' ", 
        "data frame should only contain unique group names.")
    
    expect_error(createEnrichMapMultiComplex(
        gostObjectList=list(gostTerm, gostTerm), 
        queryInfo=queryDataFrame, showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1, force=FALSE), error_message, 
        fixed=TRUE)
})

