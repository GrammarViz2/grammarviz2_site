---
morea_type: experience
morea_id: experience-a2
title: "Time series anomaly detection using GrammarViz 2.0 CLI (command line interface)"
published: true
morea_summary: "The second experiential learning event."
morea_sort_order: 2
morea_labels:
 - tutorial
---

### Experiential Learning 2

## Anomaly discovery with GrammarViz 2.0 using command line interface

### 1. Introduction
In this module we discuss the anomaly detection in QTDB 0606 ECG dataset. This data set (database record) can be downloaded from [PHYSIONET FTP](http://physionet.org/physiobank/database/qtdb/) and converted into the text format by executing this command
<pre>
rdsamp -r sele0606 -f 120.000 -l 60.000 -p -c | sed -n '701,3000p' >0606.csv
</pre>
in the linux shell (assuming that you have rdsamp installed at your system).
We use the second column of this file. This is our dataset overview:

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/qtdb0606.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

We know, that the third heartbeat of this dataset contains the true anomaly as it was discussed in [HOTSAX paper by Eamonn Keogh, Jessica Lin, and Ada Fu](http://www.cs.gmu.edu/~jessica/publications/discord_icdm05.pdf). Note, that the authors were specifically interested in finding anomalies which are shorter than a regular heartbeat following a suggestion given by the domain expert: "_... We conferred with cardiologist, Dr. Helga Van Herle M.D., who informed us that heart irregularities can sometimes manifest themselves at scales significantly shorter than a single heartbeat...._"
Figure 13 of the paper further explains the nature of this true anomaly:

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/demo-ecg0606_cluster.png" width="400px" class="img-responsive center-block">
    </div>
  </div>
</div>

## 2. Running GrammarViz 2.0 using CLI interface
Note, that by default, the GrammarViz 2.0 jar file is configured to launch GUI.
In contrast, in this tutorial, we will be using command line.
Here is an example of running GrammarViz 2.0 anomaly discovery module using CLI:

<pre>
$ java -cp "target/grammarviz2-0.0.1-SNAPSHOT-jar-with-dependencies.jar" net.seninp.grammarviz.GrammarVizAnomaly
Usage: &lt;main class&gt; [options] 
  Options:
    --algorithm, -alg
       The algorithm to use
       Default: RRA
       Possible Values: [BRUTEFORCE, HOTSAX, RRA]
    --alphabet_size, -a
       SAX alphabet size
       Default: 4
    --data, -i
       The input file name
    --output, -o
       The output file prefix
       Default: &lt;empty string&gt;
    --discords_num, -n
       The algorithm to use
       Default: 5
    --gi, -g
       GI algorithm to use
       Default: Sequitur
       Possible Values: [Sequitur, Re-Pair]
    --strategy
       Numerosity reduction strategy
       Default: EXACT
       Possible Values: [NONE, EXACT, MINDIST]
    --threshold
       Normalization threshold
       Default: 0.01
    --window_size, -w
       Sliding window size
       Default: 170
    --word_size, -p
       PAA word size
       Default: 4
</pre>

As shown, the code prints a help output expecting a number of parameters to be specified. The expected parameters are:

 - The dataset name.
 - A discord discovery algorithm to use, depending on this choice, other parameters are required.
 - A number specifying how many discords to discover.
 - The output files prefix, if none is given, no files produced.
 - The GI algorithm switch.
 - The SAX transform parameters:
   - the sliding window size;
   - the PAA transform size;
   - the alphabet size;
   - the Z-normalization threshold value.

### 2.1. Brute-force discord discovery
Let's find discords in our dataset using the brute-force discord search:

<pre>
$ java -cp "target/grammarviz2-0.0.1-SNAPSHOT-jar-with-dependencies.jar" \
    net.seninp.grammarviz.GrammarVizAnomaly -alg BRUTEFORCE -i data/ecg0606_1.csv -w 100
GrammarViz2 CLI anomaly discovery
parameters:
 input file:                  data/ecg0606_1.csv
 output files prefix:         
 Algorithm implementation:    BRUTEFORCE
 Num. of discords to report:  5
 SAX sliding window size:     100

09:25:45.110 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - Reading data ...
09:25:45.154 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - read 2299 points from data/ecg0606_1.csv
09:25:45.154 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - running brute force algorithm...

discord #0 "#0", at 411 distance to closest neighbor: 1.5045846602966542, info string: "elapsed time: 1s699ms, distance calls: 4403702"
discord #1 "#1", at 37 distance to closest neighbor: 0.4787744771810631, info string: "elapsed time: 1s312ms, distance calls: 4004102"
discord #2 "#2", at 1566 distance to closest neighbor: 0.44370598373247144, info string: "elapsed time: 1s199ms, distance calls: 3725326"
discord #3 "#3", at 539 distance to closest neighbor: 0.44370598373247144, info string: "elapsed time: 1s94ms, distance calls: 3325726"
discord #4 "#4", at 188 distance to closest neighbor: 0.41770204691861385, info string: "elapsed time: 980ms, distance calls: 3069982"

5 discords found in 6s285ms
</pre>

as shown, the best discord has been found at the position 411:

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/ecg0606_brute_force100.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

### 2.2. [HOT-SAX](http://www.cs.ucr.edu/~eamonn/discords/)-driven discords discovery.
Now let's use HOT-SAX algorithm to find discords:

<pre>
$ java -cp "target/grammarviz2-0.0.1-SNAPSHOT-jar-with-dependencies.jar" \
    net.seninp.grammarviz.GrammarVizAnomaly -alg HOTSAX -i data/ecg0606_1.csv -w 100 -p 3 -a 3 --strategy NONE

GrammarViz2 CLI anomaly discovery
parameters:
 input file:                  data/ecg0606_1.csv
 output files prefix:         
 Algorithm implementation:    HOTSAX
 Num. of discords to report:  5
 SAX sliding window size:     100
 SAX PAA size:                3
 SAX alphabet size:           3
 SAX numerosity reduction:    NONE
 SAX normalization threshold: 0.01

09:30:47.811 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - Reading data ...
09:30:47.851 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - read 2299 points from data/ecg0606_1.csv
09:30:47.851 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - running HOT SAX hashtable-based algorithm...

discord #0 "cab", at 411 distance to closest neighbor: 1.5045846602966542, info string: elapsed time: 218ms, distance calls: 138449"
discord #1 "bbc", at 37 distance to closest neighbor: 0.4787744771810631, info string: "elapsed time: 340ms, distance calls: 292766"
discord #2 "bbb", at 539 distance to closest neighbor: 0.44370598373247144, info string: "elapsed time: 389ms, distance calls: 382983"
discord #3 "bbb", at 1566 distance to closest neighbor: 0.44370598373247144, info string: "elapsed time: 273ms, distance calls: 323578"
discord #4 "bbc", at 188 distance to closest neighbor: 0.41770204691861385, info string: "elapsed time: 295ms, distance calls: 338823"

5 discords found in 1s590ms
</pre>

since HOT-SAX is an exact algorithm, it finds exactly the same discords as the brute-force.

### 2.3. Rare Rule Anomaly (RRA) -driven discords discovery.
Now let's use our proposed algorithm:

<pre>
$ java -cp "target/grammarviz2-0.0.1-SNAPSHOT-jar-with-dependencies.jar" \
    net.seninp.grammarviz.GrammarVizAnomaly -alg RRA -i data/ecg0606_1.csv -w 100 -p 3 -a 3

GrammarViz2 CLI anomaly discovery
parameters:
 input file:                  data/ecg0606_1.csv
 output files prefix:         
 Algorithm implementation:    RRA
 Num. of discords to report:  5
 SAX sliding window size:     100
 SAX PAA size:                3
 SAX alphabet size:           3
 SAX numerosity reduction:    EXACT
 SAX normalization threshold: 0.01
 GI Algorithm:                Sequitur

10:17:03.717 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - Reading data ...
10:17:03.755 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - read 2299 points from data/ecg0606_1.csv
10:17:03.755 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - running RRA algorithm...
10:17:03.853 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - 33 Sequitur rules inferred in 53ms
10:17:03.854 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - the whole timeseries is covered by rule intervals ...
10:17:03.933 [main] INFO  n.s.g.anomaly.RRAImplementation - 5 discords found in 78ms
discord #0 info string: "position 417, length 110, NN distance 0.0524406591041029, elapsed time: 45ms, distance calls: 1192"
discord #1 info string: "position 1222, length 117, NN distance 0.03299117620892709, elapsed time: 9ms, distance calls: 1480"
discord #2 info string: "position 2094, length 139, NN distance 0.010810115607678493, elapsed time: 7ms, distance calls: 1292"
discord #3 info string: "position 780, length 124, NN distance 0.009775294705352, elapsed time: 10ms, distance calls: 1296"
discord #4 info string: "position 0, length 126, NN distance 0.009762227378847584, elapsed time: 4ms, distance calls: 1065"

5 discords found in 179ms
</pre>

significantly faster, RRA finds approximately the same best discord:

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/ecg0606_RRA.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

other discords, however, are different from brute force and HOT-SAX runs -- an issue which we address below...

## 3. Auxiliary files
If we add the seventh parameter to the CLI command:

<pre>
$ java -cp "target/grammarviz2-0.0.1-SNAPSHOT-jar-with-dependencies.jar" net.seninp.grammarviz.GrammarVizAnomaly 3 data/ecg0606_1.csv 100 3 3 3 true
</pre>

the code produces two files: `distances.txt` and `coverage.txt`.

### 3.1 `distances.txt`
This file consists of three columns:

1. The time series position.
2. The distance to closest non-self match.
3. The subsequence length.

Something like this:

<pre>
$ head distances.txt
0,0.4839679741470506,126.0
1,0.0,0.0
2,0.0,0.0
...
</pre>

By using this file we can visually inspect how the discovered by RRA discord is rated among other subsequences.
Here is the [R](http://cran.r-project.org/) code we use (note that you'd need the [ggplot2](http://ggplot2.org/) and Cairo libs installed too):

<pre>
data=read.csv(file="../data/ecg0606_1.csv",header=F,sep=",")
distances=read.csv(file="../distances.txt",header=F,sep=",")
df=data.frame(time=c(1:length(data$V1)),value=distances$V2,width=distances$V3)
(pd <- ggplot(df, aes(time, value)) + geom_line(color="red") + theme_bw() +
  ggtitle("Non-self distance to the nearest neighbor among subsequences corresponding to Sequitur rules") + 
  theme(plot.title = element_text(size = rel(1.5)), axis.title.x = element_blank(),axis.title.y=element_blank(),
        axis.ticks.y=element_blank(),axis.text.y=element_blank())
)
CairoPNG(file = "ecg0606_distances.png", width = 800, height = 200, pointsize = 12, bg = "white")
print(pd)
dev.off()
</pre>

and which produces the next figure:

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/ecg0606_distances.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

### 3.2 `coverage.txt`
This file is a single column file that contains exactly the amount of lines as the input file and reflects the **rule density curve**.
Here is the way to visualize this curve using R:

<pre>
density=read.csv(file="../coverage.txt",header=F,sep=",")
density_df=data.frame(time=c(1:length(density$V1)),value=density$V1)
shade <- rbind(c(0,0), density_df, c(2229,0))
names(shade)<-c("x","y")
(pc <- ggplot(density_df, aes(x=time,y=value)) +
  geom_line(col="cyan2") + theme_bw() +
  geom_polygon(data = shade, aes(x, y), fill="cyan", alpha=0.5) +
  ggtitle("Sequitur rules density for (w=100,p=3,a=3)") + 
  theme(plot.title = element_text(size = rel(1.5)), axis.title.x = element_blank(),
        axis.title.y=element_blank(),axis.ticks.y=element_blank(),axis.text.y=element_blank()))
CairoPNG(file = "ecg0606_density1.png",
         width = 800, height = 200, pointsize = 12, bg = "white")
print(pc)
dev.off()
</pre>

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/ecg0606_density1.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

As shown above, the rule-density curve does not identify the anomaly clearly.
This is a **typical density curve behavior** when the SAX approximation is loose -- consider the figure below which shows that the area where the successful
discovery of this true anomaly with Density Curve approach is twice as small as the area of RRA success:

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/ecg0606_areas.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

If we increase values for PAA and Alphabet discretization coefficients from 3 to 5 and the numerosity reduction strategy to NONE, the situation improves significantly -- not only the true anomaly
becomes clearly articulated by the drop in rule density curve, but **most** of RRA discords now coincide with those reported by brute force and HOT-SAX algorithms:

<pre>
$ java -cp "target/grammarviz2-0.0.1-SNAPSHOT-jar-with-dependencies.jar" \
    net.seninp.grammarviz.GrammarVizAnomaly -alg RRA -i data/ecg0606_1.csv -w 100 -p 5 -a 5 --strategy NONE

GrammarViz2 CLI anomaly discovery
parameters:
 input file:                  data/ecg0606_1.csv
 output files prefix:         
 Algorithm implementation:    RRA
 Num. of discords to report:  5
 SAX sliding window size:     100
 SAX PAA size:                5
 SAX alphabet size:           5
 SAX numerosity reduction:    NONE
 SAX normalization threshold: 0.01
 GI Algorithm:                Sequitur

10:24:47.500 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - Reading data ...
10:24:47.542 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - read 2299 points from data/ecg0606_1.csv
10:24:47.543 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - running RRA algorithm...
10:24:47.703 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - 257 Sequitur rules inferred in 117ms
10:24:47.707 [main] INFO  n.s.grammarviz.GrammarVizAnomaly - the whole timeseries is covered by rule intervals ...
10:24:48.164 [main] INFO  n.s.g.anomaly.RRAImplementation - 5 discords found in 456ms
discord #0 info string: "position 409, length 101, NN distance 0.01653509811461176, elapsed time: 130ms, distance calls: 28051"
discord #1 info string: "position 36, length 102, NN distance 0.010424593293204278, elapsed time: 73ms, distance calls: 30322"
discord #2 info string: "position 623, length 102, NN distance 0.007555224086403445, elapsed time: 74ms, distance calls: 28657"
discord #3 info string: "position 1977, length 101, NN distance 0.006775670795858492, elapsed time: 79ms, distance calls: 51673"
discord #4 info string: "position 1739, length 101, NN distance 0.006647871587763073, elapsed time: 96ms, distance calls: 40432"

5 discords found in 622ms

</pre>

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/ecg0606_density2.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>


## 4. Discussion.
We discussed two new ways to discover time series anomaly (i.e., discord) -- the Rare Rule Anomaly (RRA) algorithm and the rule density curve.
As shown, the RRA algorithm is faster than other discord discovery techniques, namely brute-force and HOT-SAX.
In addition, we have shown that the approximation degree is crucial for the optimal performance of RRA and rule density curve algorithms.

## 5. The R code to combine all three plots into a nice figure.

<div class="container">
  <div class="row">
    <div class="col-sm-8">
      <img style="margin-top: 5px; margin-bottom: 5px" src="../assets/ecg0606_three_plots.png" width="800px" class="img-responsive center-block">
    </div>
  </div>
</div>

<pre>
# libs!
require(Cairo)
require(ggplot2)
require(grid)
require(gridExtra)
#
data=read.csv(file="../data/ecg0606_1.csv",header=F,sep=",")
plot(data$V1,t="l")
#
df=data.frame(time=c(1:length(data$V1)),value=data$V1)
(p <- ggplot(df, aes(time, value)) + geom_line(lwd=0.65,color="blue1") +
  ggtitle("Dataset ECG qtdb 0606 [701-3000] and the best RRA discord") + 
  theme(plot.title = element_text(size = rel(1.5)), axis.title.x = element_blank(),axis.title.y=element_blank(),
        axis.ticks.y=element_blank(),axis.text.y=element_blank())
)  
red_line=df[406:(406+114),]
p = p + geom_line(data=red_line,col="red", lwd=1.6)
CairoPNG(file = "ecg0606_RRA.png",
         width = 800, height = 200, pointsize = 12, bg = "white")
print(p)
dev.off()

#
data=read.csv(file="../data/ecg0606_1.csv",header=F,sep=",")
distances=read.csv(file="../distances.txt",header=F,sep=",")
df=data.frame(time=c(1:length(data$V1)),value=distances$V2,width=distances$V3)
pd <- ggplot(df, aes(time, value)) + geom_line(color="red") + theme_bw() +
  ggtitle("Non-self distance to the nearest neighbor among subsequences corresponding to Sequitur rules") + 
  theme(plot.title = element_text(size = rel(1.5)), axis.title.x = element_blank(),axis.title.y=element_blank(),
        axis.ticks.y=element_blank(),axis.text.y=element_blank())
pd  
CairoPNG(file = "ecg0606_distances.png",
         width = 800, height = 200, pointsize = 12, bg = "white")
print(pd)
dev.off()

#
density=read.csv(file="../coverage.txt",header=F,sep=",")
density_df=data.frame(time=c(1:length(density$V1)),value=density$V1)
shade <- rbind(c(0,0), density_df, c(2229,0))
names(shade)<-c("x","y")
(pc <- ggplot(density_df, aes(x=time,y=value)) +
  geom_line(col="cyan2") + theme_bw() +
  geom_polygon(data = shade, aes(x, y), fill="cyan", alpha=0.5) +
  ggtitle("Sequitur rules density for ECG qtdb 0606 (w=100,p=5,a=5)") + 
  theme(plot.title = element_text(size = rel(1.5)), axis.title.x = element_blank(),
        axis.title.y=element_blank(),axis.ticks.y=element_blank(),axis.text.y=element_blank()))
CairoPNG(file = "ecg0606_density2.png",
         width = 800, height = 300, pointsize = 12, bg = "white")
print(pc)
dev.off()
#
CairoPNG(file = "ecg0606_three_plots.png",
         width = 800, height = 600, pointsize = 12, bg = "white")
print(arrangeGrob(p,pd,pc,ncol=1))
dev.off()
</pre>

<!-- Add a github ribbon. -->
<link rel="stylesheet" href="../../css/gh-fork-ribbon.css">
<div class="github-fork-ribbon-wrapper right">
  <div class="github-fork-ribbon">
    <a href="https://github.com/GrammarViz2/grammarviz2_src">GrammarViz on GitHub</a>
  </div>
</div>