---
title: "SAX discretization parameters optimization"
weight: 1
pagekind: "tutorial"
summary: "Finding optimal discretization parameters for motif and discord discovery with the GrammarViz 3.0 GUI sampler."
labels:
  - tutorial
---
## 1. Introduction

Choosing the SAX discretization parameters — sliding window, PAA, and alphabet size — is the least pleasant part of grammar-based pattern discovery: set them poorly and the grammar either drowns in redundant rules or misses the structure entirely. GrammarViz 3.0 automates the choice with a parameter sampler built on the grammar-reduction heuristic described in the [companion reading]({{< ref "/optimization/reading-o1" >}}): it grids over the parameter space, prunes each candidate grammar, and keeps the parameter set whose pruned grammar describes the series most compactly. This tutorial walks through one full sampler session in the GUI.

## 2. Example dataset

We use the `ann_gun_CentroidA` dataset that ships with GrammarViz (`data/ann_gun_CentroidA1.csv`) — a video-tracking series recording the hand centroid of an actor repeatedly drawing and aiming a prop gun. The series combines a strongly repetitive gesture with irregular episodes, which makes it a good subject for both motif and anomaly discovery:

{{< fig src="ann-sampling_.png" w="800" alt="The ann_gun_CentroidA dataset loaded in GrammarViz: a repetitive gun-draw gesture signal" >}}

## 3. Selecting the sampling interval and parameter ranges

Load the dataset and select a *training interval* for the sampler by dragging over the plot. Two rules of thumb: prefer an interval that reflects the signal's normal, repetitive behavior (avoid anomalous episodes — they bias the grammar toward one-off rules), and keep it short for a long series, since the sampler infers a grammar for every grid point:

{{< fig src="ann-sampling0.png" w="800" alt="Selecting the sampling interval over a regular stretch of the signal" >}}

Click "Guess" to open the sampler dialog. It shows the selected interval and lets you configure the minimal rule cover threshold and, for each of the three parameters, the MIN / MAX / STEP of the sampling grid:

{{< fig src="ann-sampling1.png" w="800" alt="The sampler dialog: interval range, minimal cover threshold, and window/PAA/alphabet grid boundaries" >}}

The defaults are sensible for a first pass. For the window range, anything from 10 up to roughly twice the length of the phenomenon you expect works; for PAA, 2–50; for the alphabet, 2–15. A grammar whose rules cover less than the threshold (default 0.99) of the interval is discarded as not describing the series in full.

## 4. The sampling process

Click "Sample" and the sampler sweeps the grid, inferring, pruning, and scoring a grammar per point; the status bar tracks progress and the run can be interrupted at any time — the best point found so far is kept:

{{< fig src="ann-sampling2.png" w="800" alt="The sampler sweeping the parameter grid; progress reported in the status bar" >}}

When the run finishes, the discretization parameter fields are set to the winning combination — for this dataset and interval, window 145, PAA 6, alphabet 4.

## 5. Using the selected parameters — numerous rules

Click "Discretize" with the sampled parameters. The full grammar is still large — the rules panel lists over a hundred rules, many overlapping, because Sequitur records *every* repeated structure it sees:

{{< fig src="ann-sampling3.png" w="800" alt="The full inferred grammar: many overlapping rules covering the series" >}}

## 6. Pruning the grammar, motif discovery

Click "Prune rules". The greedy set-cover pass reduces the grammar to a handful of non-redundant rules that still cover the series; what remains reads as the series' motif inventory. The top surviving rule tiles the signal with the repeated draw-and-aim gesture — the dataset's dominant motif:

{{< fig src="ann-sampling4.png" w="800" alt="The pruned grammar: a few non-redundant rules; the top rule highlights the recurring gesture as a motif" >}}

## 7. Pruning the grammar, RRA anomaly discovery

Finally, click "Find anomalies" to run [RRA]({{< ref "/anomaly" >}}) on the pruned grammar. Because the discretization was chosen to describe the *regular* structure compactly, the subsequences that resist that description surface as top-ranked, variable-length anomalies:

{{< fig src="ann-sampling5.png" w="800" alt="RRA anomalies discovered with the sampled parameters highlighted on the plot" >}}

That is the whole loop: select a representative interval, sample, discretize, prune — then read motifs off the surviving rules and anomalies off the rare ones. The sampler turns the parameter guessing game into a single supervised step; the theory behind the reduction-coefficient target it optimizes is covered in the [companion reading]({{< ref "/optimization/reading-o1" >}}).
