
#' @title Using functional enrichment results in  gprofiler2 format to create  
#' an enrichment map
#' 
#' @description User selected enrichment terms are used to create an enrichment 
#' map. The selection of the term can by specifying by the 
#' source of the terms (GO:MF, REAC, TF, etc...) or by listing the selected 
#' term IDs. The map is only generated when there is at least on 
#' significant term to graph.
#' 
#' @param gostObject a \code{list} corresponding to gprofiler2 enrichment 
#' output that contains and that contains 
#' the results from an enrichment analysis.
#' 
#' @param query a \code{character} string representing the name of the query 
#' that is going to be used to generate the graph. The query must exist in the 
#' \code{gostObject} object.
#' 
#' @param source a \code{character} string representing the selected source 
#' that will be used to generate the network. To hand-pick the terms to be 
#' used, "TERM_ID" should be used and the list of selected term IDs should
#' be passed through the \code{termIDs} parameter. The possible sources are 
#' "GO:BP" for Gene Ontology Biological Process, "GO:CC" for Gene Ontology  
#' Cellular Component, "GO:MF" for Gene Ontology Molecular Function, 
#' "KEGG" for Kegg, "REAC" for Reactome, "TF" for TRANSFAC, "MIRNA" for 
#' miRTarBase, "CORUM" for CORUM database, "HP" for Human phenotype ontology
#' and "WP" for WikiPathways.  Default: "TERM_ID".
#' 
#' @param removeRoot a \code{logical} that specified if the root terms of 
#' the selected source should be removed (when present). Default: \code{TRUE}.
#' 
#' @param termIDs a \code{vector} of \code{character} strings that contains the
#' term IDS retained for the creation of the network. Default: \code{NULL}.
#' 
#' @param showCategory a positive \code{integer} or a \code{vector} of 
#' \code{characters} representing terms.  If a \code{integer}, the first 
#' \code{n} terms will be displayed. If \code{vector} of terms, 
#' the selected terms will be displayed. Default: \code{30L}.
#' 
#' @param groupCategory a \code{logical} indicating if the categories should 
#' be grouped. Default: \code{FALSE}.
#' 
#' @param categoryLabel a positive \code{numeric} representing the amount by 
#' which plotting category nodes label size should be scaled relative 
#' to the default (1). Default: \code{1}.s
#' 
#' @param categoryNode a positive \code{numeric} representing the amount by 
#' which plotting category nodes should be scaled relative to the default (1).
#' Default: \code{1}.
#'
#' @param line a non-negative \code{numeric} representing the scale of line 
#' width. Default: \code{1}.
#' 
#' @param force a \code{logical} indicating if the repulsion between 
#' overlapping text labels should be forced. Default: \code{TRUE}.
#'
#' @return a \code{ggplot} object which is the enrichment map for enrichment 
#' results.
#' 
#' @examples
#'
#' ## Loading dataset containing result from an enrichment analysis done with
#' ## gprofiler2
#' data(parentalNapaVsDMSOEnrichment)
#'
#' ## Extract query information (only one in this dataset)
#' query <- unique(parentalNapaVsDMSOEnrichment$result$query)
#' 
#' ## Create graph for Gene Ontology - Cellular Component related results
#' createEnrichMap(gostObject=parentalNapaVsDMSOEnrichment, 
#'     query=query, source="GO:CC", removeRoot=TRUE)
#' 
#' 
#' @author Astrid Deschênes
#' @importFrom gprofiler2 gconvert
#' @importFrom strex match_arg
#' @encoding UTF-8
#' @export
createEnrichMap <- function(gostObject, query, source=c("TERM_ID", "GO:MF", 
        "GO:CC", "GO:BP", "KEGG", "REAC", "TF", "MIRNA", "HPA", "CORUM", 
        "HP", "WP"), termIDs=NULL, removeRoot=TRUE,  
        showCategory=30L, groupCategory=FALSE, categoryLabel=1,
        categoryNode=1, line=1, force=TRUE) {
    
    ## Validate source is among the possible choices
    source <- match_arg(source, ignore_case=TRUE)
    
    ## Validate parameters
    validateCreateEnrichMapArguments(gostObject=gostObject, query=query, 
        source=source, termIDs=termIDs, removeRoot=removeRoot, 
        showCategory=showCategory, categoryLabel=categoryLabel,
        groupCategory=groupCategory, categoryNode=categoryNode, 
        line=line, force=force)
    
    ## Extract results
    gostResults <- gostObject$result
    
    ## Retain results associated to query
    gostResults <- gostResults[gostResults$query == query,]
    
    ## Filter results
    if (source == "TERM_ID") {
        gostResults <- gostResults[gostResults$term_id %in% termIDs,]
    } else {
        gostResults <- gostResults[gostResults$source == source,]
    }
    
    ## Remove root term if required
    if (removeRoot) {
        gostResults <- removeRootTerm(gostResults)
        if (nrow(gostResults) == 0) {
            stop("With removal of the root term, there is no ", 
                    "enrichment term left")
        }
    }
    
    meta <- gostObject$meta
    
    backgroundGenes <- meta$query_metadata$queries[[query]]
    
    significantMethod <- meta$query_metadata$significance_threshold_method
    
    ## Create basic emap
    emap <- createBasicEmap(gostResults=gostResults, 
                backgroundGenes=backgroundGenes, 
                showCategory=showCategory, categoryLabel=categoryLabel,
                groupCategory=groupCategory, categoryNode=categoryNode, 
                significantMethod=significantMethod, line=line, force=force)
    
    return(emap)
}


#' @title Using functional enrichment results in gprofiler2 format to create  
#' an enrichment map with multiple groups from different enrichment analyses
#' 
#' @description User selected enrichment terms are used to create an enrichment 
#' map. The selection of the term can by specifying by the 
#' source of the terms (GO:MF, REAC, TF, etc...) or by listing the selected 
#' term IDs. The map is only generated when there is at least on 
#' significant term to graph.
#' 
#' @param gostObjectList a \code{list} of \code{gprofiler2} objects that 
#' contain the results from an enrichment analysis. The list must contain at 
#' least 2 entries. The number of entries must correspond to the number of 
#' entries for the \code{queryList} parameter.
#' 
#' @param queryList a \code{list} of \code{character} strings representing the 
#' names of the queries that are going to be used to generate the graph. 
#' The query names must exist in the associated \code{gostObjectList} objects 
#' and follow the same order. The number of entries must correspond to the 
#' number of entries for the \code{gostObjectList} parameter.
#' 
#' @param source a \code{character} string representing the selected source 
#' that will be used to generate the network. To hand-pick the terms to be 
#' used, "TERM_ID" should be used and the list of selected term IDs should
#' be passed through the \code{termIDs} parameter. The possible sources are 
#' "GO:BP" for Gene Ontology Biological Process, "GO:CC" for Gene Ontology  
#' Cellular Component, "GO:MF" for Gene Ontology Molecular Function, 
#' "KEGG" for Kegg, "REAC" for Reactome, "TF" for TRANSFAC, "MIRNA" for 
#' miRTarBase, "CORUM" for CORUM database, "HP" for Human phenotype ontology
#' and "WP" for WikiPathways.  Default: "TERM_ID".
#' 
#' @param removeRoot a \code{logical} that specified if the root terms of 
#' the selected source should be removed (when present). Default: \code{TRUE}.
#' 
#' @param termIDs a \code{vector} of \code{character} strings that contains the
#' term IDS retained for the creation of the network. Default: \code{NULL}.
#' 
#' @param showCategory a positive \code{integer} or a \code{vector} of 
#' \code{characters} representing terms.  If a \code{integer}, the first 
#' \code{n} terms will be displayed. If \code{vector} of terms, 
#' the selected terms will be displayed. Default: \code{30L}.
#' 
#' @param groupCategory a \code{logical} indicating if the categories should 
#' be grouped. Default: \code{FALSE}.
#' 
#' @param categoryLabel a positive \code{numeric} representing the amount by 
#' which plotting category nodes label size should be scaled relative 
#' to the default (1). Default: \code{1}.
#' 
#' @param categoryNode a positive \code{numeric} representing the amount by 
#' which plotting category nodes should be scaled relative to the default (1).
#' Default: \code{1}.
#' 
#' @param line a non-negative \code{numeric} representing the scale of line 
#' width. Default: \code{1}.
#'
#' @param force a \code{logical} indicating if the repulsion between 
#' overlapping text labels should be forced. Default: \code{TRUE}.
#' 
#' @return a \code{ggplot} object which is the enrichment map for enrichment 
#' results.
#' 
#' @examples
#'
#' ## Loading dataset containing results from 2 enrichment analyses done with
#' ## gprofiler2
#' data(parentalNapaVsDMSOEnrichment)
#' data(rosaNapaVsDMSOEnrichment)
#'
#' ## Extract query information (only one in each dataset)
#' query1 <- unique(parentalNapaVsDMSOEnrichment$result$query)[1]
#' query2 <- unique(rosaNapaVsDMSOEnrichment$result$query)[1]
#' 
#' ## Create graph for KEGG related results from 
#' ## 2 enrichment analyses
#' createEnrichMapMultiBasic(gostObjectList=list(parentalNapaVsDMSOEnrichment, 
#'     rosaNapaVsDMSOEnrichment), 
#'     queryList=list(query1, query2), source="KEGG", removeRoot=TRUE)
#' 
#' 
#' @author Astrid Deschênes
#' @importFrom gprofiler2 gconvert
#' @importFrom strex match_arg
#' @encoding UTF-8
#' @export
createEnrichMapMultiBasic <- function(gostObjectList, queryList, 
    source=c("TERM_ID", "GO:MF", "GO:CC", "GO:BP", "KEGG", "REAC", "TF", 
    "MIRNA", "HPA", "CORUM", "HP", "WP"), termIDs=NULL, removeRoot=TRUE, 
    showCategory=30L, groupCategory=FALSE, categoryLabel=1, 
    categoryNode=1, line=1, force=TRUE) {
    
    ## Validate source is among the possible choices
    source <- match_arg(source, ignore_case=TRUE)
    
    ## Validate parameters
    validateCreateEnrichMapMultiArguments(gostObjectList=gostObjectList, 
        queryList=queryList, source=source, termIDs=termIDs, 
        removeRoot=removeRoot, showCategory=showCategory, 
        categoryLabel=categoryLabel, groupCategory=groupCategory, 
        categoryNode=categoryNode, line=line, force=force)
    
    ## Extract results
    gostResultsList <- lapply(gostObjectList, FUN=function(x) {x$result})
    
    ## Retain results associated to query
    gostResultsList <- lapply(seq_len(length(queryList)), 
        FUN=function(i, queryL, gostL) {
            gostL[[i]][gostL[[i]]$query == queryL[[i]], ]}, 
        queryL=queryList, gostL=gostResultsList)
    
    ## Filter results
    if (source == "TERM_ID") {
        gostResultsList <- lapply(gostResultsList,  FUN=function(x, termIDs) {
            x[x$term_id %in% termIDs,]}, termIDs=termIDs)
    } else {
        gostResultsList <- lapply(gostResultsList,  FUN=function(x, source) {
            x[x$source == source,]}, source=source)
    }
    
    ## Remove root term if required
    if (removeRoot) {
        gostResultsList <- lapply(gostResultsList,  FUN=function(x) {
            removeRootTerm(x)})
    }
    
    ## Validate that at least one term is left
    if (sum(unlist(lapply(gostResultsList,  FUN=function(x) {nrow(x)})))  
            == 0) {
        stop("With removal of the root term, there is no ", 
                    "enrichment term left")
    }
    
    ## Create multi categories emap
    emap <- createMultiEmap(gostResultsList=gostResultsList, 
                queryList=queryList, showCategory=showCategory, 
                categoryLabel=categoryLabel, groupCategory=groupCategory, 
                categoryNode=categoryNode, line=line, force=force)
    
    return(emap)
}


#' @title Using functional enrichment results in gprofiler2 format to create  
#' an enrichment map with multiple groups from same or different enrichment 
#' analyses
#' 
#' @description User selected enrichment terms are used to create an enrichment 
#' map. The selection of the term can by specifying by the 
#' source of the terms (GO:MF, REAC, TF, etc...) or by listing the selected 
#' term IDs. The map is only generated when there is at least on 
#' significant term to graph.
#' 
#' @param gostObjectList a \code{list} of \code{gprofiler2} objects that 
#' contain the results from an enrichment analysis. The list must contain at 
#' least 2 entries. The number of entries must correspond to the number of 
#' entries for the \code{queryList} parameter.
#' 
#' @param queryInfo a \code{data.frame} contains one row per group being 
#' displayed. The number of rows must correspond to the 
#' number of entries for the \code{gostObjectList} parameter. 
#' The mandatory columns are:
#' \itemize{
#' \item{\code{queryName}: a \code{character} string representing the name 
#' of the query retained for this group). The query names must exist in the 
#' associated \code{gostObjectList} objects and follow the same order. }
#' \item{\code{source}: a \code{character} string representing the selected 
#' source that will be used to generate the network. To hand-pick the terms to 
#' be used, "TERM_ID" should be used and the list of selected term IDs should
#' be passed through the \code{termIDs} parameter. The possible sources are 
#' "GO:BP" for Gene Ontology Biological Process, "GO:CC" for Gene Ontology  
#' Cellular Component, "GO:MF" for Gene Ontology Molecular Function, 
#' "KEGG" for Kegg, "REAC" for Reactome, "TF" for TRANSFAC, "MIRNA" for 
#' miRTarBase, "CORUM" for CORUM database, "HP" for Human phenotype ontology
#' and "WP" for WikiPathways.  Default: "TERM_ID". }
#' \item{\code{removeRoot}: a \code{logical} that specified if the root terms 
#' of the selected source should be removed (when present). }
#' \item{\code{termIDs}: a \code{character} strings that contains the
#' term IDS retained for the creation of the network separated by a comma ',' 
#' when the "TERM_ID" source is selected. Otherwise, it should be a empty 
#' string (""). }
#' \item{\code{groupName}: a \code{character} strings that contains the 
#' name of the group to be shown in the legend. Each group has to have a 
#' unique name. }
#' }
#' 
#' @param showCategory a positive \code{integer} or a \code{vector} of 
#' \code{characters} representing terms.  If a \code{integer}, the first 
#' \code{n} terms will be displayed. If \code{vector} of terms, 
#' the selected terms will be displayed. Default: \code{30L}.
#' 
#' @param groupCategory a \code{logical} indicating if the categories should 
#' be grouped. Default: \code{FALSE}.
#' 
#' @param categoryLabel a positive \code{numeric} representing the amount by 
#' which plotting category nodes label size should be scaled relative 
#' to the default (1). Default: \code{1}.
#' 
#' @param categoryNode a positive \code{numeric} representing the amount by 
#' which plotting category nodes should be scaled relative to the default (1).
#' Default: \code{1}.
#' 
#' @param line a non-negative \code{numeric} representing the scale of line 
#' width. Default: \code{1}.
#'
#' @param force a \code{logical} indicating if the repulsion between 
#' overlapping text labels should be forced. Default: \code{TRUE}.
#' 
#' @return a \code{ggplot} object which is the enrichment map for enrichment 
#' results.
#' 
#' @examples
#'
#' ## Loading dataset containing results from 2 enrichment analyses done with
#' ## gprofiler2
#' data(parentalNapaVsDMSOEnrichment)
#' data(rosaNapaVsDMSOEnrichment)
#'
#' ## TODO
#' gostObjectList=list(parentalNapaVsDMSOEnrichment, 
#'     parentalNapaVsDMSOEnrichment, rosaNapaVsDMSOEnrichment, 
#'     rosaNapaVsDMSOEnrichment)
#'     
#' ## Create data frame containing required information enabling the 
#' ## selection of the retained enriched terms for each enrichment analysis.
#' ## One line per enrichment analyses present in the gostObjectList parameter
#' ## With this data frame, the enrichment results will be split in 4 groups:
#' ## 1) KEGG significant terms from parental napa vs DMSO (no root term)
#' ## 2) REACTOME significant terms from parental napa vs DMSO (no root term)
#' ## 3) KEGG significant terms from rosa napa vs DMSO (no root term)
#' ## 4) REACTOME significant terms from rosa napa vs DMSO (no root term)
#' queryDataFrame <- data.frame(queryName=c("parental_napa_vs_DMSO", 
#'         "parental_napa_vs_DMSO", "rosa_napa_vs_DMSO", "rosa_napa_vs_DMSO"), 
#'     source=c("KEGG", "REAC", "KEGG", "REAC"), 
#'     removeRoot=c(TRUE, TRUE, TRUE, TRUE), termIDs=c("", "", "", ""), 
#'     groupName=c("parental - KEGG", "parental - Reactome", 
#'         "rosa - KEGG", "rosa - Reactome"), stringsAsFactors=FALSE)
#'     
#' ## Create graph for KEGG and REACTOME significant results from 
#' ## 2 enrichment analyses
#' createEnrichMapMultiComplex(gostObjectList=gostObjectList, 
#'     queryInfo=queryDataFrame, line=1.5)
#' 
#' @author Astrid Deschênes
#' @importFrom gprofiler2 gconvert
#' @importFrom strex match_arg
#' @importFrom stringr str_split str_trim
#' @encoding UTF-8
#' @export
createEnrichMapMultiComplex <- function(gostObjectList, queryInfo,  
    showCategory=30L, groupCategory=FALSE, categoryLabel=1, 
    categoryNode=1, line=1, force=TRUE) {
    
    ## Validate parameters
    validateCreateEnrichMapMultiComplexArg(gostObjectList=gostObjectList, 
        queryInfo=queryInfo, showCategory=showCategory, 
        categoryLabel=categoryLabel, groupCategory=groupCategory, 
        categoryNode=categoryNode, line=line, force=force)
    
    ## Extract results
    gostResultsList <- lapply(gostObjectList, FUN=function(x) {x$result})
    
    ## Retain results associated to query
    gostResultsList <- lapply(seq_len(length(gostObjectList)), 
        FUN=function(i, queryI, gostL) {
            gostL[[i]][gostL[[i]]$query == queryI$queryName[[i]], ]}, 
            queryI=queryInfo, gostL=gostResultsList)
    
    ## Filter results
    gostResultsList <- lapply(seq_len(length(gostObjectList)), 
        FUN=function(i, queryI, gostL) {
            if (queryI$source[i] == "TERM_ID") {
                terms <- unlist(str_split(queryI$termIDs[i], ","))
                terms <- str_trim(terms)
                return(gostL[[i]][gostL[[i]]$term_id %in% terms, ])
            } else {
                return(gostL[[i]][gostL[[i]]$source == queryI$source[i], ])
            }
        }, queryI=queryInfo, gostL=gostResultsList)
    
    
    ## Remove root terms when requested
    gostResultsList <- lapply(seq_len(length(gostObjectList)), 
        FUN=function(i, queryI, gostL) {
            if (queryI$removeRoot[i]) {
                 return(removeRootTerm(gostL[[i]]))
            } else {
                return(gostL[[i]])
            }
        }, queryI=queryInfo, gostL=gostResultsList)
    
    ## Validate that at least one term is left
    if (sum(unlist(lapply(gostResultsList,  FUN=function(x) {nrow(x)})))
            == 0) {
        stop("With removal of the root term, there is no ",
                "enrichment term left")
    }
    
    ## Create multi categories emap
    emap <- createMultiEmap(gostResultsList=gostResultsList, 
                queryList=queryInfo$groupName, showCategory=showCategory, 
                categoryLabel=categoryLabel, groupCategory=groupCategory, 
                categoryNode=categoryNode, line=line, force=force)
    
    return(emap)
}
