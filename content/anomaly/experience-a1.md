---
title: "Time series anomaly detection using GUI"
weight: 1
pagekind: "tutorial"
summary: "Discover anomalous time series patterns using the GrammarViz 3.0 graphical user interface"
labels:
  - tutorial
---
## 1. Introduction

In this module we discuss anomaly detection in the QTDB 0606 ECG dataset. The database record can be downloaded from the [PhysioNet QT Database](https://physionet.org/content/qtdb/1.0.0/) and converted into text format with

```bash
rdsamp -r sele0606 -f 120.000 -l 60.000 -p -c | sed -n '701,3000p' >0606.csv
```

(assuming `rdsamp` from the [WFDB toolkit](https://physionet.org/content/wfdb/) is installed on your system). We use the second column of this file; a ready-made copy ships with GrammarViz as [`data/ecg0606_1.csv`](https://github.com/GrammarViz2/grammarviz2_src/blob/master/data/ecg0606_1.csv). This is our dataset overview:

{{< fig src="qtdb0606.png" w="800" alt="Overview plot of the 2,299-point QTDB 0606 ECG excerpt" >}}

We know that the third heartbeat of this dataset contains the true anomaly, as discussed in the [HOT SAX paper by Eamonn Keogh, Jessica Lin, and Ada Fu](https://www.cs.ucr.edu/~eamonn/HOT%20SAX%20%20long-ver.pdf). Note that the authors were specifically interested in finding anomalies *shorter* than a regular heartbeat, following a suggestion by a domain expert: "_...We conferred with cardiologist, Dr. Helga Van Herle M.D., who informed us that heart irregularities can sometimes manifest themselves at scales significantly shorter than a single heartbeat..._" Figure 13 of the paper further explains the nature of this anomaly:

{{< fig src="demo-ecg0606_cluster.png" w="400" alt="Figure 13 from the HOT SAX paper: the anomalous third heartbeat contrasted with normal beats" >}}

## 2. Variable-length exact anomaly discovery with RRA

Load the dataset with the "Load data" button and set the SAX discretization parameters to sliding window 100, PAA 3, and alphabet 3. Click "Discretize" to infer a grammar describing the input time series. Click the "Find anomalies" button to perform the discovery, then select the "GrammarViz anomalies" tab and choose the top-ranked anomaly (#0):

{{< fig src="demo-ecg0606_03.png" w="800" alt="GrammarViz GUI with the top-ranked RRA anomaly highlighted on the ECG plot" >}}

This highlights the grammar rule that coincides with the true anomaly. Note the *variable lengths*: the top anomaly is 110 points long, while the next one spans 208 points.

## 3. Variable-length approximate anomaly discovery with the rule density curve

We use the same dataset. First, change the GI algorithm from Sequitur to Re-Pair: open "Settings", choose the "GI Implementation" tab, and toggle the Re-Pair algorithm:

{{< fig src="demo-ecg0606_02.png" w="800" alt="GrammarViz settings dialog with the Re-Pair grammar inference algorithm selected" >}}

Click "Save" to apply. Set the SAX discretization parameters to sliding window 100, PAA 5, and alphabet 5, and click "Discretize" to infer a Re-Pair grammar. Then click the "Rules density" button:

{{< fig src="demo-ecg0606_01.png" w="800" alt="Rule density curve over the ECG series; the light region near position 480 marks the anomaly" >}}

The light (low-density) region near position 480 clearly identifies the true anomaly: few grammar rules cover it, which is exactly what makes it rare.

## 4. Discussion

Note that both techniques shown above yield rare subsequences of *variable length*. Two factors make this possible: the numerosity reduction embedded in the discretization step, and the nature of GI algorithms, which build their rules from long-range correlations in the input.
