---
title: "Time series anomaly detection using CLI"
weight: 2
pagekind: "tutorial"
summary: "Discover anomalous time series patterns using the GrammarViz 3.0 command line interface"
labels:
  - tutorial
---
## 1. Introduction

> All transcripts below were captured with GrammarViz 3.0.4 (`grammarviz2-3.0.4-jar-with-dependencies.jar`, built with `mvn package -DskipTests` from [the source]({{< param github >}})). Timings will vary with your hardware.

In this module we discuss anomaly detection in the QTDB 0606 ECG dataset. The database record can be downloaded from the [PhysioNet QT Database](https://physionet.org/content/qtdb/1.0.0/) and converted into text format with

```bash
rdsamp -r sele0606 -f 120.000 -l 60.000 -p -c | sed -n '701,3000p' >0606.csv
```

(assuming `rdsamp` from the [WFDB toolkit](https://physionet.org/content/wfdb/) is installed on your system). We use the second column of this file; a ready-made copy ships with GrammarViz as `data/ecg0606_1.csv`. This is our dataset overview:

{{< fig src="qtdb0606.png" w="800" alt="Overview plot of the 2,299-point QTDB 0606 ECG excerpt" >}}

We know that the third heartbeat of this dataset contains the true anomaly, as discussed in the [HOT SAX paper by Eamonn Keogh, Jessica Lin, and Ada Fu](https://www.cs.ucr.edu/~eamonn/HOT%20SAX%20%20long-ver.pdf). Note that the authors were specifically interested in finding anomalies *shorter* than a regular heartbeat, following a suggestion by a domain expert: "_...We conferred with cardiologist, Dr. Helga Van Herle M.D., who informed us that heart irregularities can sometimes manifest themselves at scales significantly shorter than a single heartbeat..._" Figure 13 of the paper further explains the nature of this anomaly:

{{< fig src="demo-ecg0606_cluster.png" w="400" alt="Figure 13 from the HOT SAX paper: the anomalous third heartbeat contrasted with normal beats" >}}

## 2. Running the anomaly discovery CLI

By default, the GrammarViz jar launches the GUI; the CLI lives in a separate class. Running it without parameters prints the usage help:

```text
$ java -cp "target/grammarviz2-3.0.4-jar-with-dependencies.jar" net.seninp.grammarviz.GrammarVizAnomaly
Usage: <main class> [options]
  Options:
    --algorithm, -alg
      The algorithm to use
      Default: RRA
      Possible Values: [BRUTEFORCE, HOTSAX, RRA, RRAPRUNED, RRASAMPLED, EXPERIMENT]
    --alphabet_size, -a
      SAX alphabet size
      Default: 4
    --bounds, -b
      RRASAMPLED grid boundaries (Wmin Wmax Wstep Pmin Pmax Pstep Amin Amax Astep)
      Default: 10 100 10 10 50 10 2 12 2
    --data, -i
      The input file name
    --discords_num, -n
      The number of discords to report
      Default: 5
    --gi, -g
      GI algorithm to use
      Default: Sequitur
      Possible Values: [Sequitur, Re-Pair]
    --help, -h

    --output, -o
      The output file prefix
      Default: <empty string>
    --strategy
      Numerosity reduction strategy
      Default: EXACT
      Possible Values: [NONE, EXACT, MINDIST]
    --subsample
      RRASAMPLED subsampling fraction (0.0 - 1.0) for longer time series
      Default: NaN
    --threshold
      Normalization threshold
      Default: 0.01
    --window_size, -w
      Sliding window size
      Default: 170
    --word_size, -p
      PAA word size
      Default: 4
```

The essential parameters are the input file (`-i`), the discord discovery algorithm (`-alg`), the number of discords to report (`-n`), the optional output file prefix (`-o`, see section 3), the GI algorithm switch (`-g`), and the SAX transform parameters: sliding window size (`-w`), PAA size (`-p`), alphabet size (`-a`), and the z-normalization threshold (`--threshold`).

### 2.1. Brute-force discord discovery

Let's find discords in our dataset using the brute-force search — every subsequence compared against every other:

```text
$ java -cp "target/grammarviz2-3.0.4-jar-with-dependencies.jar" \
    net.seninp.grammarviz.GrammarVizAnomaly -alg BRUTEFORCE -i data/ecg0606_1.csv -w 100

GrammarViz2 CLI anomaly discovery
parameters:
 input file:                  data/ecg0606_1.csv
 output files prefix:
 Algorithm implementation:    BRUTEFORCE
 Num. of discords to report:  5
 SAX sliding window size:     100

... INFO GrammarVizAnomaly - read 2299 points from data/ecg0606_1.csv
... INFO GrammarVizAnomaly - running brute force algorithm...

discord #0 "#0", at 430 distance to closest neighbor: 5.279080006170648, ... distance calls: 4405801
discord #1 "#1", at 318 distance to closest neighbor: 4.175756357304875, ... distance calls: 4005801
discord #2 "#2", at 2080 distance to closest neighbor: 2.3929983241637354, ... distance calls: 3781801
discord #3 "#3", at 25 distance to closest neighbor: 2.3755413245159973, ... distance calls: 3378561
discord #4 "#4", at 1198 distance to closest neighbor: 2.064930309436058, ... distance calls: 3123611

5 discords found in 0d0h0m8s900ms
```

As shown, the best discord is found at position 430 — at the cost of nearly 20 million distance computations:

{{< fig src="ecg0606_brute_force100.png" w="800" alt="ECG series with the best brute-force discord at position 430 highlighted in red" >}}

### 2.2. HOT SAX discord discovery

Now let's use the [HOT SAX](https://www.cs.ucr.edu/~eamonn/discords/) algorithm, which prunes the search using SAX-word frequencies:

```text
$ java -cp "target/grammarviz2-3.0.4-jar-with-dependencies.jar" \
    net.seninp.grammarviz.GrammarVizAnomaly -alg HOTSAX -i data/ecg0606_1.csv -w 100 -p 3 -a 3 --strategy NONE

...
discord #0 "acc", at 430 distance to closest neighbor: 5.279080006170648, ... distance calls: 105967
discord #1 "cab", at 318 distance to closest neighbor: 4.175756357304875, ... distance calls: 120452
discord #2 "caa", at 2080 distance to closest neighbor: 2.3929983241637354, ... distance calls: 128799
discord #3 "cab", at 25 distance to closest neighbor: 2.3755413245159973, ... distance calls: 120557
discord #4 "cab", at 1198 distance to closest neighbor: 2.064930309436058, ... distance calls: 136437

5 discords found in 0d0h0m0s820ms
```

Since HOT SAX is an exact algorithm, it finds precisely the same discords as brute force — an order of magnitude faster, with roughly 30× fewer distance calls.

### 2.3. Rare Rule Anomaly (RRA) discord discovery

Now let's use our proposed algorithm, which ranks the subsequences that correspond to *rarely used grammar rules*:

```text
$ java -cp "target/grammarviz2-3.0.4-jar-with-dependencies.jar" \
    net.seninp.grammarviz.GrammarVizAnomaly -alg RRA -i data/ecg0606_1.csv -w 100 -p 3 -a 3

...
... INFO GrammarVizAnomaly - 33 Sequitur rules inferred in 0d0h0m0s38ms
discord #0, at 417: length 109, NN distance 0.12040929130766632, ... distance calls: 1156
discord #1, at 1809: length 208, NN distance 0.09274217265342169, ... distance calls: 949
discord #2, at 27: length 222, NN distance 0.09187429531381004, ... distance calls: 564
discord #3, at 526: length 231, NN distance 0.08975407632177715, ... distance calls: 675
discord #4, at 1202: length 120, NN distance 0.08975407632177715, ... distance calls: 828

5 discords found in 0d0h0m0s160ms
```

RRA is faster still — note the mere thousands of distance calls — and its best discord (position 417, length 109) approximately coincides with the true anomaly. Note also the *variable lengths* of the reported discords, from 109 to 231 points; neither brute force nor HOT SAX can do that. (The NN distances are not comparable to §2.1/§2.2: RRA normalizes distances by the subsequence length.)

{{< fig src="ecg0606_RRA.png" w="800" alt="ECG series with the best RRA discord highlighted; it overlaps the true anomaly" >}}

The remaining RRA discords, however, differ from the brute-force and HOT SAX results — an issue we address below.

### 2.4. Wall-clock scaling: RRA vs HOT-SAX

The CLI examples above compare **distance-call counts** on ecg0606 (2,299 points). That is the right metric for understanding search efficiency, but users also care about **end-to-end wall time**, which includes grammar construction for RRA (parallel SAX + Re-Pair + interval build). The tables below summarize a controlled Java benchmark on GrammarViz **3.0.4** / jmotif-sax **2.0.1** (MacBook-class hardware, Jul 2026). Each run reports **one** discord (`k = 1`), `seed = 0`, numerosity **NONE**, z-normalization threshold **0.01**. Ratios below **1.0×** mean RRA was faster wall-clock.

**Short series (ecg0606, `n = 2,299`):**

| Parameters | HOT-SAX | RRA | RRA / HOT-SAX |
|------------|---------|-----|---------------|
| `w=120, p=4, a=4` | 50 ms | 75 ms | 1.50× slower |
| `w=100, p=4, a=4` | 19 ms | 29 ms | 1.53× slower |
| `w=150, p=7, a=4` | 77 ms | 71 ms | **0.92× faster** |

On this demo excerpt, HOT-SAX usually wins wall-clock: the fixed grammar cost dominates when the series is only a few thousand points long. Parameter choice still matters (`w=150, p=7` is the exception above).

**Longer ECG-like series (`w=100, p=4, a=4`, one discord):**

| Series | `n` | HOT-SAX | RRA | RRA / HOT-SAX |
|--------|-----|---------|-----|---------------|
| ecg0606 (baseline) | 2,299 | 44 ms | 82 ms | 1.86× slower |
| chfdbchf15 (`data/chfdbchf15_1.csv`) | 15,000 | 265 ms | 215 ms | **0.81× faster** |
| chfdb tiled + tiny drift | 50,000 | 10.6 s | 2.3 s | **~0.21× (~5× faster)** |
| chfdb tiled + tiny drift | 100,000 | 21.0 s | 7.8 s | **~0.37× (~2.7× faster)** |

**Plausible explanation.** HOT-SAX prunes the sliding-window search using SAX-word frequencies but still walks the word index structure over the full series. RRA pays an upfront cost to infer a grammar and build rule intervals, then searches only over those **variable-length** grammar-derived candidates — often **orders of magnitude fewer distance computations** on long series (consistent with the distance-call reductions already visible in §2.2–§2.3). On short series that fixed cost is not amortized; on series of roughly **10k–15k** points and beyond, RRA's reduced search space typically wins wall-clock. The crossover depends on `(window, PAA, alphabet)`, hardware, and how compressible the SAX string is.

**Caveats (read before comparing numbers):**

- **Not a conformance claim.** These tables measure **speed**, not agreement on the top discord span. [jmotif-conformance](https://github.com/jMotif/jmotif-conformance) tier-B RRA checks **region overlap** on ecg0606 because grammar-rule intervals legitimately differ in exact boundaries across implementations.
- **NN distances are not comparable** between HOT-SAX (fixed window, z-normalized subsequence distance) and RRA (length-normalized distance on grammar spans) — compare wall time and rank, not the printed `nn` values.
- **Avoid exact periodic tiling** of a short excerpt (e.g. repeating ecg0606 verbatim). HOT-SAX can degenerate (very long run, zero discords reported) when every cycle is an exact clone; the 50k/100k rows above tile **chfdbchf15** with a tiny per-cycle drift instead.
- **Top positions may differ** on long tiled runs even when both algorithms find a valid discord — different search spaces, not necessarily a bug.

For reproducibility notes and caveats, see the [conformance README benchmark section](https://github.com/jMotif/jmotif-conformance#rra-vs-hot-sax-wall-clock-informative-not-conformance) (regenerate with `./scripts/bench_rra_hotsax.sh --update-readme`).

## 3. Auxiliary files

If we add an output prefix via `-o`, the CLI writes two files whose names start with the prefix:

```text
$ java -cp "target/grammarviz2-3.0.4-jar-with-dependencies.jar" \
    net.seninp.grammarviz.GrammarVizAnomaly -alg RRA -i data/ecg0606_1.csv -w 100 -p 3 -a 3 -o ecg0606
```

This run produces `ecg0606_distances.txt` and `ecg0606_coverage.txt`.

### 3.1. The distances file

`ecg0606_distances.txt` has three columns: the time series position, the distance to the closest non-self match, and the subsequence length:

```text
$ head -3 ecg0606_distances.txt
0,0.4839679741470506,126.0
1,0.0,0.0
2,0.0,0.0
```

Using this file we can visually inspect how the RRA discord ranks among all rule-covered subsequences. Here is the [R](https://cran.r-project.org/) code we use (you will need the [ggplot2](https://ggplot2.tidyverse.org/) and Cairo packages):

```r
data = read.csv(file = "data/ecg0606_1.csv", header = F, sep = ",")
distances = read.csv(file = "ecg0606_distances.txt", header = F, sep = ",")
df = data.frame(time = c(1:length(data$V1)), value = distances$V2, width = distances$V3)
(pd <- ggplot(df, aes(time, value)) + geom_line(color = "red") + theme_bw() +
  ggtitle("Non-self distance to the nearest neighbor among subsequences corresponding to Sequitur rules") +
  theme(plot.title = element_text(size = rel(1.5)), axis.title.x = element_blank(), axis.title.y = element_blank(),
        axis.ticks.y = element_blank(), axis.text.y = element_blank())
)
CairoPNG(file = "ecg0606_distances.png", width = 800, height = 200, pointsize = 12, bg = "white")
print(pd)
dev.off()
```

which produces the next figure:

{{< fig src="ecg0606_distances.png" w="800" alt="Nearest-neighbor distance curve over the ECG series; the spike marks the top discord" >}}

### 3.2. The coverage file

`ecg0606_coverage.txt` is a single-column file with exactly as many lines as the input has points; it holds the **rule density curve** — for each point, the number of grammar rules whose subsequences cover it. Here is how to visualize it in R:

```r
density = read.csv(file = "ecg0606_coverage.txt", header = F, sep = ",")
density_df = data.frame(time = c(1:length(density$V1)), value = density$V1)
shade <- rbind(c(0,0), density_df, c(2299,0))
names(shade) <- c("x","y")
(pc <- ggplot(density_df, aes(x = time, y = value)) +
  geom_line(col = "cyan2") + theme_bw() +
  geom_polygon(data = shade, aes(x, y), fill = "cyan", alpha = 0.5) +
  ggtitle("Sequitur rules density for (w=100,p=3,a=3)") +
  theme(plot.title = element_text(size = rel(1.5)), axis.title.x = element_blank(),
        axis.title.y = element_blank(), axis.ticks.y = element_blank(), axis.text.y = element_blank()))
CairoPNG(file = "ecg0606_density1.png",
         width = 800, height = 200, pointsize = 12, bg = "white")
print(pc)
dev.off()
```

{{< fig src="ecg0606_density1.png" w="800" alt="Rule density curve for w=100, PAA 3, alphabet 3 — the anomaly is not clearly visible" >}}

As shown above, at this coarse discretization the rule density curve does *not* identify the anomaly clearly. This is typical density-curve behavior when the SAX approximation is loose — consider the figure below, which shows that the parameter region where the density curve successfully finds this anomaly is about half the size of the region where RRA succeeds:

{{< fig src="ecg0606_areas.png" w="800" alt="Parameter-space comparison: the region of successful discovery is about twice as large for RRA as for the density curve" >}}

If we increase the PAA and alphabet sizes from 3 to 5 and set the numerosity reduction strategy to NONE, the situation improves significantly: not only does the true anomaly become clearly articulated by the drop in the rule density curve, but most RRA discords now coincide with those reported by brute force and HOT SAX:

```text
$ java -cp "target/grammarviz2-3.0.4-jar-with-dependencies.jar" \
    net.seninp.grammarviz.GrammarVizAnomaly -alg RRA -i data/ecg0606_1.csv -w 100 -p 5 -a 5 --strategy NONE

...
... INFO GrammarVizAnomaly - 257 Sequitur rules inferred in 0d0h0m0s68ms
discord #0, at 430: length 101, NN distance 0.06262134977716174, ... distance calls: 14602
discord #1, at 316: length 101, NN distance 0.03448338808657879, ... distance calls: 11757
discord #2, at 24: length 101, NN distance 0.032198131031693035, ... distance calls: 14569
discord #3, at 2082: length 101, NN distance 0.030021038948161417, ... distance calls: 18068
discord #4, at 1498: length 101, NN distance 0.021162714061307847, ... distance calls: 27080

5 discords found in 0d0h0m0s709ms
```

{{< fig src="ecg0606_density2.png" w="800" alt="Rule density curve for w=100, PAA 5, alphabet 5 — a clear drop marks the anomaly" >}}

## 4. Discussion

We discussed two grammar-based ways to discover time series anomalies (discords): the Rare Rule Anomaly (RRA) algorithm and the rule density curve. RRA reports discords of **variable length** and, on long series, can be **substantially faster wall-clock than HOT-SAX** once grammar construction is amortized (see §2.4). On the short ecg0606 demo excerpt, HOT-SAX is often faster end-to-end because RRA's Re-Pair and interval setup dominate; distance-call counts still favor RRA even there. Brute force remains the correctness baseline but is impractical at scale.

We have also shown that the degree of approximation is crucial for both RRA and the rule density curve: a discretization that is too coarse blurs the anomaly, and a modest increase in PAA and alphabet sizes brings the grammar-based results in line with the exact algorithms.

## 5. Combining all three plots into one figure

{{< fig src="ecg0606_three_plots.png" w="800" alt="Three stacked panels: the ECG series with the RRA discord, the nearest-neighbor distance curve, and the rule density curve" >}}

```r
require(Cairo)
require(ggplot2)
require(grid)
require(gridExtra)

data = read.csv(file = "data/ecg0606_1.csv", header = F, sep = ",")
df = data.frame(time = c(1:length(data$V1)), value = data$V1)
(p <- ggplot(df, aes(time, value)) + geom_line(lwd = 0.65, color = "blue1") +
  ggtitle("Dataset ECG qtdb 0606 [701-3000] and the best RRA discord") +
  theme(plot.title = element_text(size = rel(1.5)), axis.title.x = element_blank(), axis.title.y = element_blank(),
        axis.ticks.y = element_blank(), axis.text.y = element_blank())
)
red_line = df[417:(417+109),]
p = p + geom_line(data = red_line, col = "red", lwd = 1.6)

distances = read.csv(file = "ecg0606_distances.txt", header = F, sep = ",")
df = data.frame(time = c(1:length(data$V1)), value = distances$V2, width = distances$V3)
pd <- ggplot(df, aes(time, value)) + geom_line(color = "red") + theme_bw() +
  ggtitle("Non-self distance to the nearest neighbor among subsequences corresponding to Sequitur rules") +
  theme(plot.title = element_text(size = rel(1.5)), axis.title.x = element_blank(), axis.title.y = element_blank(),
        axis.ticks.y = element_blank(), axis.text.y = element_blank())

density = read.csv(file = "ecg0606_coverage.txt", header = F, sep = ",")
density_df = data.frame(time = c(1:length(density$V1)), value = density$V1)
shade <- rbind(c(0,0), density_df, c(2299,0))
names(shade) <- c("x","y")
pc <- ggplot(density_df, aes(x = time, y = value)) +
  geom_line(col = "cyan2") + theme_bw() +
  geom_polygon(data = shade, aes(x, y), fill = "cyan", alpha = 0.5) +
  ggtitle("Sequitur rules density for ECG qtdb 0606 (w=100,p=5,a=5)") +
  theme(plot.title = element_text(size = rel(1.5)), axis.title.x = element_blank(),
        axis.title.y = element_blank(), axis.ticks.y = element_blank(), axis.text.y = element_blank())

CairoPNG(file = "ecg0606_three_plots.png", width = 800, height = 600, pointsize = 12, bg = "white")
print(arrangeGrob(p, pd, pc, ncol = 1))
dev.off()
```
