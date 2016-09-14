---
morea_type: reading
morea_id: reading-o1
title: "SAX discretization parameters optimization"
published: true
#topdiv: other
morea_summary: "Discusses SAX discretization parameters optimization approach implemented in GrammarViz 3.0."
morea_sort_order: 1
morea_labels:
 - algoritms
---

## GrammarViz 3.0 approach for SAX discretization parameters optimization.
In this module we describe the GrammarViz 3.0 approach for the automated discretization parameters selection.

### 1. SAX approximation precision.
First, we start by introducing the SAX approximation precision.

### 2. Grammar rules numerosity.
The grammar-based time series decomposition offers an advantageous capability to find patterns of different lengths. However, the hierarchical and the variable-length natures of the patterns mean that often they are numerous and overlapping. While this specificity aids time series anomaly discovery via rule density curve, the large number of overlapping time series motif candidates is difficult to examine visually. Thus, the capacity of pruning and organizing rules in an intelligent way and a mechanism for their automated pruning are highly desirable. 

### 3. Greedy rule pruning approach.
The second heuristic is built similar to the greedy solution of minimum-cardinality set cover problem (an NP-hard problem) \cite{karpCover} \cite{young2008greedy} and attempts to find the smallest set of rules which cover the most of the input time series in a greedy fashion.


### 4. Grammar size reduction coefficient.

### 5. SAX parameters optimization procedure in GrammarViz 3.0.

### 6. Discussion.
