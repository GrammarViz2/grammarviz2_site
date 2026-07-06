---
title: "Time series recurrent pattern (motif) discovery using GUI"
weight: 2
pagekind: "tutorial"
summary: "Discover recurrent time series patterns using the GrammarViz 3.0 graphical user interface"
labels:
  - tutorial
---
## 1. Introduction

We discuss two use cases that show how the GrammarViz GUI discovers time series patterns of variable length.

## 2. Datasets used

Two datasets are used in this demo:

### 2.1. Winding dataset

This [dataset](https://github.com/GrammarViz2/grammarviz2_src/blob/master/data/winding.dat.gz?raw=true) is a snapshot of data collected from an industrial [winding process](https://homes.esat.kuleuven.be/~smc/daisy/) (the DaISy collection's test setup of an industrial winding process); its column #2 corresponds to the traction reel angular speed:

{{< fig src="winding_col2.png" w="800" alt="The winding dataset: traction reel angular speed over 2,500 samples" >}}

### 2.2. QTDB 0606 ECG dataset

The database record can be downloaded from the [PhysioNet QT Database](https://physionet.org/content/qtdb/1.0.0/) and converted into text format with

```bash
rdsamp -r sele0606 -f 120.000 -l 60.000 -p -c | sed -n '701,3000p' >0606.csv
```

(assuming `rdsamp` from the [WFDB toolkit](https://physionet.org/content/wfdb/) is installed on your system). We use the second column of this file; a ready-made copy ships with GrammarViz as `data/ecg0606_1.csv`. This is our dataset overview:

{{< fig src="qtdb0606.png" w="800" alt="Overview plot of the 2,299-point QTDB 0606 ECG excerpt" >}}

We know that the third heartbeat of this dataset contains the true anomaly, as discussed in the [HOT SAX paper by Eamonn Keogh, Jessica Lin, and Ada Fu](https://www.cs.ucr.edu/~eamonn/HOT%20SAX%20%20long-ver.pdf) — see the [anomaly discovery tutorials]({{< ref "/anomaly" >}}) for that side of the story. Here, we are after the *recurring* patterns.

## 3. Time series discretization and grammar induction

There are two ways to perform the discretization: globally, or with an overlapping sliding window (toggled by the "Slide the window" checkbox). We use sliding window-based discretization in this demo.

The discretization is configured by three numeric parameters: the sliding window size, the PAA size, and the alphabet size. These control the granularity of the approximation, which in turn drives the sensitivity and selectivity of the higher-level algorithms — for example, the ability to capture a local phenomenon. Note, however, that the grammar induction step effectively mitigates a suboptimal sliding window choice, because rules compose across windows. The grammar induction itself requires no parameters.

## 4. Variable-length recurrent pattern discovery

We use the winding dataset in this example. Click "Browse...", select `winding.csv`, then "Load data" — the GUI plots the winding data. Now set the discretization parameters: window size 100, PAA size 4, alphabet size 3. Click "Discretize". At this point the GUI displays the inferred grammar rules.

Click the "Mean length" column header to sort the rule table in ascending order; click it again for descending. Select the rule with the longest mean length — the GUI shows that this rule spans about 353 points and is observed twice:

{{< fig src="demo-winding01.png" w="800" alt="GrammarViz GUI with the longest grammar rule selected; its two ~353-point occurrences are highlighted on the winding plot" >}}

Similar long rules are also observed twice each, at lengths of roughly 227 and 187 points.

Now click the "Frequency in R0" column header twice and choose the most frequent rule:

{{< fig src="demo-winding02.png" w="800" alt="GrammarViz GUI with the most frequent rule selected; its occurrences of varying length are highlighted" >}}

The subsequences corresponding to this rule range in length from 102 to 121 points, and a few of them overlap.

*Note that these variable-length subsequences correspond to a single rule of the same grammar inferred by Sequitur from the discretized time series.*

Similarly, if we load the `qtdb0606` ECG dataset with the discretization parameters set to sliding window 100, PAA 8, and alphabet 4, the algorithm finds that the most frequently occurring rules are the normal heartbeats:

{{< fig src="demo-ecg0606_02.png" w="800" alt="GrammarViz GUI on the ECG dataset: the most frequent grammar rule matches the normal heartbeats" >}}

## 5. Discussion

Note that the recurrent pattern discovery technique shown above yields sets of frequent subsequences of *variable length*. Two factors make this possible: the numerosity reduction embedded in the discretization step, and the nature of GI algorithms, which build their rules from long-range correlations in the input.
