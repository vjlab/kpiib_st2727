
prune.Large.Tree <- function(xtree,keep=NULL,drop=NULL) {

my.subtrees.pruned=subtrees(xtree) 
	x=my.subtrees.pruned[[1]]
	tipEdges=1:length(x$tip.label) 
	LabelEdges=which(x$edge[,2]%in%tipEdges)									
	xx=data.frame(edge.length=x$edge.length[LabelEdges],edge=x$edge[LabelEdges,])
	uniqueBranches <- xx[!duplicated(xx$edge.length),]
	
	TipsKeep=c(x$tip.label[uniqueBranches$edge.2],keep) 
	TipsKeep=TipsKeep[-which(TipsKeep%in%drop)] 
	TipsKeep=unique(TipsKeep)
	Xtree=drop.tip(x, x$tip.label[-na.omit(match(TipsKeep, x$tip.label))])
				
				return(Xtree)						
	
							}		
							
							
							
										
	
