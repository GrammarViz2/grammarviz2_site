---
title: "Temporal anomaly discovery"
weight: 101
pagekind: "reading"
summary: "A survey of previous work on time series anomaly discovery, from discords and HOT SAX to compression-based approaches."
labels:
  - previous work
---
*This section, adapted from our EDBT 2015 paper, surveys previous work on time series anomaly discovery.*

The brute-force solution to time series anomaly detection — or, more specifically, to the discovery of a discord of a given length \(n\) in a time series \(T\) of length \(m\) — has to consider all possible distances between each subsequence \(C\) of length \(n\) and all of its non-self matches \(M\) \((C, M \in T)\). This method requires \(O(m^{2})\) calls to the distance function and is simply untenable for large datasets.

To mitigate this heavy computational requirement, previous work suggests reordering the subsequence comparisons for efficient pruning. For example HOT SAX [1], the pioneering work on discord discovery, proposes a fast heuristic technique capable of exact discord discovery by ordering subsequences by their potential degree of discordance. Similarly, in [2] the authors use locality-sensitive hashing to estimate the similarity between shapes, which lets them reorder the search to discover unusual shapes efficiently. The authors of [3] and [4] use Haar wavelets and augmented tries to achieve effective pruning of the search space. While these approaches achieve speed-ups of several orders of magnitude over the brute-force algorithm, their common drawback is that they require the length of a potential anomaly as input, and they output discords of that fixed length only. In addition, even with pruning, they rely on distance computations which, as noted by Keogh et al. [1], account for more than 99% of these algorithms' run time.

An interesting approach to finding anomalies in a very large database (a terabyte-sized dataset) was shown by Yankov et al. [5]. The authors propose an algorithm that requires only two scans through the database. However, this method needs an anomaly-defining range \(r\) as input, and when used to detect an unusual subsequence within a time series it also requires the length of the potential discord.

Some techniques introduce approximate solutions that avoid distance computations on the raw time series altogether. VizTree [6] is a time series visualization tool that enables the simultaneous discovery of both frequent and rare (anomalous) patterns. VizTree uses a trie — a tree data structure with constant-time lookups — to decode the frequency of occurrence of all patterns in their discretized form. Similar to VizTree, Chen et al. [7] also consider anomalies to be the most infrequent time series patterns; they use the support count to compute each pattern's anomaly score. Although their definition of anomalies resembles discords, their technique requires more input parameters (the slope precision \(e\), the number of anomalous patterns \(k\), and a minimum threshold), and the anomalies discussed in their paper consist of only two points. Wei et al. [8] suggest another method, which measures similarity with time series bitmaps.

Finally, some previous work has examined the use of algorithmic randomness for time series anomaly discovery. Arning et al. [9] proposed a linear-time algorithm for anomaly detection in sequential databases: by simulating a natural mechanism of memorizing previously seen data with regular-expression-based abstractions that capture observed redundancy, their technique detects deviations in linear time. The method, however, relies on a user-defined entity size (the database record size). Alternatively, Keogh et al. [10] have shown an algorithmic-randomness-based, parameter-free approach to approximate anomaly detection (the WCAD algorithm). Built upon an off-the-shelf compressor, their technique requires numerous compressor executions, which makes it computationally expensive; in addition, it requires the sliding window (i.e., anomaly) size to be specified.

Beyond the works mentioned above, the extensive empirical study by Chandola et al. [11] provides further detail on time series anomaly discovery.

[1] Keogh, E., Lin, J., Fu, A., <em>HOT SAX: Efficiently Finding the Most Unusual Time Series Subsequence</em>, In Proc. ICDM'05 (2005)<br>
[2] Wei, L., Keogh, E., Xi, X., <em>SAXually explicit images: Finding unusual shapes</em>, In Proc. ICDM (2006)<br>
[3] Fu, A., Leung, O., Keogh, E., Lin, J., <em>Finding Time Series Discords based on Haar Transform</em>, In Proc. of Intl. Conf. on Adv. Data Mining and Applications (2006)<br>
[4] Bu, Y., Leung, O., Fu, A., Keogh, E., Pei, J., Meshkin, S., <em>WAT: Finding Top-K Discords in Time Series Database</em>, In Proc. of SIAM Intl. Conf. on Data Mining (2007)<br>
[5] Yankov, D., Keogh, E., Rebbapragada, U., <em>Disk aware discord discovery: finding unusual time series in terabyte sized data sets</em>, Knowledge and Information Systems, 241-262 (2008)<br>
[6] Lin, J., Keogh, E., Lonardi, S., Lankford, J.P., Nystrom, D. M., <em>Visually mining and monitoring massive time series</em>, In Proc. ACM SIGKDD Int'l Conf. on KDD (2004)<br>
[7] Chen, X., Zhan, Y., <em>Multi-scale Anomaly Detection Algorithm based on Infrequent Pattern of Time Series</em>, J. of Computational and Applied Mathematics (2008)<br>
[8] Wei, L., Kumar, N., Lolla, V., Keogh, E., Lonardi, S., Ratanamahatana, C., <em>Assumption-free Anomaly Detection in Time Series</em>, In Proc. SSDBM (2005)<br>
[9] Arning, A., Agrawal, R., Raghavan, P., <em>A Linear Method for Deviation Detection in Large Databases</em>, In KDD (pp. 164-169) (1996)<br>
[10] Keogh, E., Lonardi, S., Ratanamahatana, C.A., <em>Towards parameter-free data mining</em>, In Proc. KDD (2004)<br>
[11] Chandola, V., Cheboli, D., and Kumar, V., <em>Detecting Anomalies in a Time Series Database</em>, CS TR 09-004 (2009)
