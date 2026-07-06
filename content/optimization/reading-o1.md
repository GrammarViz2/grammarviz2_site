---
title: "SAX discretization parameters optimization"
weight: 101
pagekind: "reading"
summary: "The theory behind the GrammarViz 3.0 parameter sampler: SAX approximation error, grammar cover, rule pruning, and the reduction coefficient."
labels:
  - algorithm
---
In this module we describe the GrammarViz 3.0 approach to automated discretization parameter selection.

## 1. SAX approximation error

The SAX approximation error can be seen as the sum of two error values computed for each subsequence extracted via the sliding window: (i) the PAA approximation error, and (ii) the SAX transform approximation error. Both are shown schematically in the right panels of the figure below:

{{< fig src="sax-error.png" w="800" alt="Schematic of the two SAX approximation error components: PAA error and alphabet (symbol) error" >}}

The PAA approximation error is the mean absolute deviation between the z-normalized time series points and their corresponding PAA values:

$$ \text{Error}_{\text{PAA}}(C_{p,p+n}) =
\frac{
 \sum\limits_{i=p}^{i \lt p+n}\left|C_{i}-PAA_{C_{i}}\right|
}{n}
$$

where \(C\) is the subsequence of the time series \(T\) extracted via a sliding window of length \(n\).

The SAX approximation error is the mean absolute deviation between the PAA values and the centers of the SAX alphabet cut segments to which these values map:

$$
\text{Error}_{\text{Alphabet}}(C_{PAA^{k}}) =
\frac{
 \sum\limits_{i=0}^{i \lt k}\left|C_{PAA^{k}}^{i}-CutCenter(C_{PAA^{k}}^{i})\right|
}{k}
$$

where \(k\) is the PAA size and \(C_{PAA^{k}}\) is the PAA transform of \(C\). The value of \(CutCenter(C_{PAA^{k}}^{i})\) is taken from a table of precomputed values similar to the SAX cut lines table.

The intuition behind this error function is that it captures the average distance between a time series point and its SAX representation over the whole series. Naturally, as the PAA and alphabet parameters grow, the approximation error decreases, as shown in the figure below, where the surface values are averaged over sliding windows ranging from 30 to 400:

{{< fig src="sax-error-results.png" w="800" alt="Approximation error surface: the error decreases as PAA and alphabet sizes increase" >}}

At the same time, as the PAA and alphabet values increase, the number and diversity of SAX words grow, and with them the total number of rules in the resulting grammar. The figure below shows that dependency indirectly, through the strong negative correlation between the approximation error and the total number of grammar rules:

{{< fig src="error-rules.png" w="800" alt="Scatter plot showing strong negative correlation between approximation error and grammar rule count" >}}

## 2. Grammar cover

To describe our redundant-rule pruning technique — and, later, the automated parameter selection — we define the *grammar cover* of a grammar \(G\) inferred from a time series \(T\) as the ratio of two values: the number of time series points located within at least one subsequence corresponding to a grammar rule, and the total length of the time series:

$$
\text{Cover}^{G}(T) = \frac{\left|\{\, t \in T : t \text{ is covered by a rule of } G \,\}\right|}{\left|T\right|}
$$

## 3. Grammar rule numerosity and pruning

Grammar-based time series decomposition offers a valuable capability: it finds patterns of different lengths. However, the hierarchical and variable-length nature of these patterns means they are often numerous and overlapping. While this abundance aids anomaly discovery via the rule density curve, a large number of overlapping motif candidates is difficult to examine visually. A mechanism for organizing and automatically pruning the rules is therefore highly desirable. We approach rule pruning with a greedy algorithm, following the classic greedy solution of the (NP-hard) minimum-cardinality set cover problem: it looks for a small set of rules that covers as much of the input time series as possible. The algorithm is shown below:

{{< fig src="pruning-alg.png" w="800" alt="Pseudocode of the greedy grammar-rule pruning algorithm: repeatedly add the rule extending the cover most, then drop rules made redundant" >}}

The algorithm's input is a grammar \(G\) describing the input time series and the time series length \(m\); its output is a reduced grammar covering the same time series. The pruning process is wrapped in an outer loop (lines 2–29), which terminates in two cases: (i) when the whole time series span is covered by the selected rules, or (ii) when the cover cannot be extended further (lines 12–14). Two inner loops run over the rules. In the first (lines 4–11), the algorithm finds the rule that extends the current cover the most. In the second (lines 16–27), it checks whether adding that rule made any previously selected rule obsolete — if so, the redundant rule is removed from the selection and set aside. When pruning finishes, the selected rules are partially expanded to account for the exclusion of some initial rules (line 30), and the resulting grammar is returned.

## 4. The intuition behind the rule pruning algorithm

The intuition is simple: since the task at hand is to find maximally repeated *and* minimally overlapping subsequences (which we consider the most informative), at each iteration we select the rule covering the most of the yet-uncovered time series span — the rule that adds the most new information about the series' structure.

A notable property of our pruning algorithm is that it searches for a minimal subset of grammar rules with *the same cover as the full grammar*. This relates it to a line of work on mining serial episodes from event sequences — Tatti (2012), Van (2014), Lam (2014) — which employs coding tables to find a minimal set of episodes describing an observed sequence succinctly and characteristically. Note also that those techniques and ours stand on the same foundation: the Minimum Description Length (MDL) and Kolmogorov complexity (i.e., algorithmic compression) formalisms.

## 5. The grammar reduction coefficient

The pruning procedure above eliminates redundant rules that do not contribute to the grammar cover. We propose using the ratio of the pruned grammar's rule count to the full grammar's rule count as the objective for selecting the optimal discretization parameters:

$$
\text{ReductionCoefficient} = \frac{\text{number of rules in the pruned grammar}}{\text{number of rules in the full grammar}}
$$

## 6. Automated discretization parameter selection

To the best of our knowledge, the problem of discretization parameter optimization for time series anomaly and frequent-pattern discovery remained unsolved. In GrammarViz 3.0 we propose a semi-automated solution whose quality increases with user participation. It is based on the inherent properties of the discretization and grammar inference processes discussed above, and proceeds as follows:

1. First, a parameter-learning interval is chosen from the input time series. If the series is short, its whole span can be used; if it is long (tens of thousands of points), selecting a shorter interval speeds up the sampling. It is also advisable to choose an anomaly- and noise-free interval reflecting the expected generative process, to avoid learning biases.
2. Second, a range of acceptable values is specified for each discretization parameter. For the sliding window, a reasonable range runs from 10 up to twice the length of a typical structural phenomenon observed in the series. For PAA, a typical range is 2 to 50 (with the window longer than the maximal PAA value); for the alphabet, 2 to 15.
3. Third, for each parameter combination within the ranges, a grammar is inferred and pruned, and the reduction coefficient is computed. Any grammar whose cover falls below a fixed threshold — usually 0.9 to 1.0, depending on the expected fraction of anomalous ranges — is discarded as not describing the input in full, and its parameter combination is marked invalid.
4. Finally, among all valid sampled combinations, the one yielding the minimal reduction coefficient is selected as the optimal discretization parameter set.

Why does minimizing the reduction coefficient work? The coefficient reflects two properties at once. It decreases when its denominator — the total number of rules — grows, which happens when the discretization parameters grow and *the approximation error falls* (see §1); this growth is kept honest by the cover threshold, which ensures that word correlations still occur and the grammar's hierarchy can describe the series in full. The coefficient also decreases when its numerator — the pruned rule count — falls, which happens when *a small number of non-redundant rules describes the series in full* (again, subject to the cover threshold). By design, then, the minimal reduction coefficient corresponds to a parameter set that describes the input with minimal approximation error while reducing the grammar to just a few non-redundant rules.

We implemented this workflow in the GrammarViz 3.0 GUI as shown below. A typical interactive session consists of a few steps that can be repeated as needed: load the dataset, explore it by panning and zooming, select a section reflecting the expected generative process, configure the sampling grid density, and run the sampler. The [hands-on tutorial]({{< ref "/optimization/experience-o1" >}}) walks through a complete session:

{{< fig src="sampler-screen.png" w="800" alt="The GrammarViz 3.0 parameter sampler dialog over a loaded time series" >}}
