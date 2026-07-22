---
title: "Time series recurrent pattern (motif) discovery using CLI"
weight: 3
pagekind: "tutorial"
summary: "Discover recurrent time series patterns using the GrammarViz 3.0 command line interface"
labels:
  - tutorial
---
## 1. Introduction

We work through the same use cases as in the [GUI tutorial]({{< ref "/motif/experience-m1" >}}), this time from the command line.

> All transcripts below were captured with GrammarViz 3.0.3 (`grammarviz2-3.0.3-jar-with-dependencies.jar`, built with `mvn package -DskipTests` from [the source]({{< param github >}})). Timings will vary with your hardware.

## 2. Datasets used

Two datasets are used in this demo:

### 2.1. Winding dataset

This [dataset](https://github.com/GrammarViz2/grammarviz2_src/blob/master/data/winding.dat.gz?raw=true) is a snapshot of data collected from an industrial [winding process](https://homes.esat.kuleuven.be/~smc/daisy/) (the DaISy collection's test setup of an industrial winding process); its column #2 corresponds to the traction reel angular speed. A single-column extract ships with GrammarViz as `data/winding_col.txt`:

{{< fig src="winding_col2.png" w="800" alt="The winding dataset: traction reel angular speed over 2,500 samples" >}}

### 2.2. QTDB 0606 ECG dataset

The database record can be downloaded from the [PhysioNet QT Database](https://physionet.org/content/qtdb/1.0.0/) and converted into text format with

```bash
rdsamp -r sele0606 -f 120.000 -l 60.000 -p -c | sed -n '701,3000p' >0606.csv
```

(assuming `rdsamp` from the [WFDB toolkit](https://physionet.org/content/wfdb/) is installed on your system). We use the second column of this file; a ready-made copy ships with GrammarViz as `data/ecg0606_1.csv`:

{{< fig src="qtdb0606.png" w="800" alt="Overview plot of the 2,299-point QTDB 0606 ECG excerpt" >}}

## 3. Using the CLI

Following the build instructions in the [source repository]({{< param github >}}) produces the stand-alone jar `grammarviz2-3.0.3-jar-with-dependencies.jar`, which we use below.

Running the jar as usual (`java -jar ...`) starts the GUI, so for CLI work we specify the class implementing the command-line interface. Run without parameters, it prints a help message:

```text
$ java -cp "target/grammarviz2-3.0.3-jar-with-dependencies.jar" net.seninp.grammarviz.cli.TS2SequiturGrammar
Usage: <main class> [options]
  Options:
    --alphabet_size, -a
      SAX alphabet size
      Default: 4
    --data_in, -d
      The input file name
    --data_out, -o
      The output file name
    --help, -h

    --num-workers, -n
      Number of worker threads to use for SAX
      Default: 1
    --prune
      Pass to prune rules
      Default: false
    --strategy
      Numerosity reduction strategy
      Default: NONE
      Possible Values: [NONE, EXACT, MINDIST]
    --threshold
      Normalization threshold
      Default: 0.01
    --window_size, -w
      Sliding window size
      Default: 30
    --word_size, -p
      PAA word size
      Default: 6
```

## 4. Variable-length recurrent pattern discovery

We use the winding dataset with a sliding window of 100, PAA size 4, alphabet size 3, and the EXACT numerosity reduction strategy:

```text
$ java -cp "target/grammarviz2-3.0.3-jar-with-dependencies.jar" net.seninp.grammarviz.cli.TS2SequiturGrammar \
    -d data/winding_col.txt -o winding_grammar.txt -w 100 -p 4 -a 3 --strategy EXACT
... INFO n.s.g.cli.TS2SequiturGrammar - GrammarViz2 CLI converter v.1
parameters:
  input file:                  data/winding_col.txt
  output file:                 winding_grammar.txt
  SAX sliding window size:     100
  SAX PAA size:                4
  SAX alphabet size:           3
  SAX numerosity reduction:    EXACT
  SAX normalization threshold: 0.01
  Pruning rules:               false

... INFO n.s.g.cli.TS2SequiturGrammar - read 2500 points from data/winding_col.txt
... INFO n.s.g.cli.TS2SequiturGrammar - Performing SAX conversion ...
... INFO n.s.g.cli.TS2SequiturGrammar - Inferring Sequitur grammar ...
... INFO n.s.g.cli.TS2SequiturGrammar - Collecting stats ...
... INFO n.s.g.cli.TS2SequiturGrammar - Producing the output ...
```

This yields the file `winding_grammar.txt` containing the inferred grammar and, for each rule, the corresponding subsequences.

The description of rule #21 in this file demonstrates the algorithm's ability to capture repeated patterns much longer than the sliding window: the two subsequences corresponding to this rule are 227 points each — well over twice the window size:

```text
/// R21
R21 -> 'R50 abbb R46 bbba bbca bbba R37 R8 bcac bbac babc cabc R49 bbcb abcb accb',
  expanded rule string: 'cbbb bbbb abbb abbc bbbc bbbb bbba bbca bbba cbba bbba bbbb bcbb bcab bcac bbac babc cabc cabb cacb bacb bbcb abcb accb '
subsequences starts: [497, 1497]
subsequences lengths: [227, 227]
rule occurrence frequency 2
rule use frequency 2
min length 227
max length 227
mean length 227
```

At the same time, the subsequences corresponding to the most frequent rule, #8, vary in length between 102 and 121 points:

```text
/// R8
R8 -> 'bcbb bcab', expanded rule string: 'bcbb bcab '
subsequences starts: [61, 115, 341, 565, 640, 690, 853, 1565, 1640, 1853, 2060, 2341]
subsequences lengths: [102, 103, 121, 109, 107, 105, 113, 109, 108, 113, 103, 120]
rule occurrence frequency 12
rule use frequency 5
min length 102
max length 121
mean length 109
```

Similarly, if we process the ECG dataset with sliding window 100, PAA 8, and alphabet 4 (`java -cp "target/grammarviz2-3.0.3-jar-with-dependencies.jar" net.seninp.grammarviz.cli.TS2SequiturGrammar -d data/ecg0606_1.csv -o ecg_grammar.txt -w 100 -p 8 -a 4 --strategy EXACT`), the algorithm finds that the most frequently occurring rule captures the normal heartbeats, 105 to 107 points long:

```text
/// R7
R7 -> 'bbcbbdab bbcbcdab', expanded rule string: 'bbcbbdab bbcbcdab '
subsequences starts: [62, 209, 506, 652, 798, 943, 1087, 1234, 1384, 1533, 1682, 1828, 1973, 2115]
subsequences lengths: [105, 107, 107, 105, 107, 106, 106, 106, 106, 107, 106, 107, 107, 107]
rule occurrence frequency 14
rule use frequency 4
min length 105
max length 107
mean length 106
```

## 5. Discussion

Note that the recurrent pattern discovery technique shown above yields sets of frequent subsequences of *variable length*. Two factors make this possible: the numerosity reduction embedded in the discretization step, and the nature of GI algorithms, which build their rules from long-range correlations in the input.
