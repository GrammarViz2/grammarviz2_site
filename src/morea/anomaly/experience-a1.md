---
morea_type: experience
morea_id: experience-a1
title: "Time series anomaly discovery using GrammarViz 2.0"
published: true
morea_summary: "The first experiential learning event."
morea_sort_order: 1
morea_labels:
 - tutorial
---

### Experiential Learning 1

## Anomaly discovery with GrammarViz 2.0

### 1. Introduction
Here we discuss an anomaly detection in QTDB 0606 ECG dataset. This record can be downloaded from [PHYSIONET FTP](http://physionet.org/physiobank/database/qtdb/) and converted into text file by executing
<pre>
rdsamp -r sele0606 -f 120.000 -l 60.000 -p -c | sed -n '701,3000p' >0606.csv
</pre>
in the linux shell. We use the second column of this file. This is the data overview:

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/qtdb0606.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

We know, that third heartbeat of this dataset contains the true anomaly as it was discussed in the [HOTSAX paper by Eamonn Keogh, Jessica Lin, and Ada Fu](http://www.cs.gmu.edu/~jessica/publications/discord_icdm05.pdf). The authors were specifically interested in finding anomalies which are shorter than a regular heartbeat following a suggestion given by a domain expert: "_... We conferred with cardiologist, Dr. Helga Van Herle M.D., who informed us that heart irregularities can sometimes manifest themselves at scales significantly shorter than a single heartbeat...._"
Figure 13 of the paper further explains the nature of an anomaly:

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/demo-ecg0606_cluster.png" width="400px" class="img-responsive center-block">
    </div>
  </div>
</div>

## 2. Variable length anomaly discovery
Load the dataset, adjust SAX discretization parameters to sliding window 100, PAA 8, and alphabet 4. Click "Process data". Click "Find anomalies" button, select the GrammarViz anomalies tab and choose the top ranked anomaly (#0):

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/demo-ecg0606_03.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

this highlights the grammar rule which coincides with the true anomaly. *Note that rule #28 is of length 123 while next anomaly, the rule #30 is of length 109*



## 3. Variable length anomaly discovery using rules density
Load the dataset, adjust SAX discretization parameters to sliding window 100, PAA 8, and alphabet 4. Click "Process data". Click on "Rules density" button:

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/demo-ecg0606_01.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

The light blue color near position 490 clearly identifies the true anomaly.
