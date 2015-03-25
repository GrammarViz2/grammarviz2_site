---
morea_type: reading
morea_id: reading-a1
title: "Temporal anomaly discovery"
published: true
topdiv: other
morea_summary: "Discusses previous work on time series anomaly discovery."
morea_sort_order: 1
morea_labels:
 - previous work
---

<style type="text/css">p {font-size: 14px;}</style>

<script type="text/x-mathjax-config">MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});</script>
<script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

<div class="section-background-1">
 <div class="container">
  <h2><strong>Previous work on anomaly detection.</strong></h2>
  <h4>This is the section from our EDBT paper that discusses previous work in time series anomaly discovery.</h4>
 </div>
</div>

<div class="row top-buffer">
 <div class="section-background-2">
  <div class="container">
       <div class="row">
       <div class="col-sm-12">

       <p> The brute force solution for the problem of time series anomaly detection or, more specifically,
       the discovery of a discord of a given length $n$ in time series $T$ of length $m$, needs to consider
       all possible distances between each sub-sequence $C$ of length $n$ and all of its non-self matches $M$ ($C,M \in T$).
       This method has $O(m^{2})$ complexity and is simply untenable for large data sets.</p>
       
       <p>To mitigate this heavy computational requirement, previous work suggests that the sub-sequence comparisons
       should be reordered for efficient pruning. For example HOTSAX [1], which is the pioneering work on
       discord discovery, suggests a fast heuristic technique that is capable of true discord discovery by reordering
       sub-sequences by their potential degree of discordance. Similarly in [2], the authors use locality
       sensitive hashing to estimate similarity between shapes with which they can efficiently reorder the search to
       discover unusual shapes. The authors of [3] and [4] use Haar wavelets and augmented tries
       to achieve effective pruning of the search space. While these approaches achieve a speed-up of several orders of
       magnitude over the brute-force algorithm, their common drawback is that they all need the length of a potential
       anomaly to be specified as the input, and they output discords of a fixed length. In addition, even with pruning,
       they rely on the distance computation which, as suggested by Keogh et al. [1], accounts for more than 99\% of
       these algorithms run-time.</p>  

       <p>An interesting approach to find anomalies in a very large database (terabyte-sized data set) was shown by
       Yankov et al.[5]. The authors proposed an algorithm that requires only two scans through the database.
       However, this method needs an anomaly defining range $r$ as the input. In addition, when used to detect an unusual
       sub-sequence within a time series, it also requires the length of the potential discord.</p> 

       <p>Some techniques introduced approximate solutions that do not require distance computation on the raw time series.
       VizTree [6] is a time series visualization tool that allows for the discovery of both frequent and rare
       (anomalous) patterns simultaneously. VizTree utilizes a trie (a tree-like data structure that allows for a constant
       time look-up) to decode the frequency of occurrences for all patterns in their discretized form. Similar to that
       defined in VizTree, Chen et al.[7] also consider anomalies to be the most infrequent time series patterns.
       The authors use support count to compute the anomaly score of each pattern. Although the definition of anomalies by Chen et al.
       is similar to discords, their technique requires more input parameters such as the precision of the slope $e$, the number of
       anomalous patterns $k$, or the minimum threshold. In addition, the anomalies discussed in their paper contain only two points.
       Wei et al. [8] suggest another method that uses time series bitmaps to measure similarity.</p> 

       <p>Finally, some previous work has examined the use of algorithmic randomness for time series anomaly discovery.
       Arning et al. [9] proposed a linear time complexity algorithm for the sequential data anomaly detection problem from
       databases. Simulating a natural mechanism of memorizing previously seen data entities with regular-expression based abstractions
       capturing observed redundancy, their technique has been shown capable of detecting deviations in linear time.
       The proposed method relies on the user-defined entity size (the database record size).
       Alternatively, Keogh et al. [10] have shown an algorithmic randomness-based parameter-free approach to approximate
       anomaly detection (the WCAD algorithm). However, built upon use of an off-shelf compressor, their technique requires its numerous
       executions, which renders it computationally expensive; in addition, it requires the sliding window (i.e., anomaly)
       size to be specified.</p>
       
       <p>
       In addition to mentioned above, an extensive empirical study by Chandola et al. [11] provides more details on time series anomaly discovery.
       <p>
       
    [1] Keogh, E., Lin, J., Fu, A.,<em> HOT SAX: Efficiently Finding the Most Unusual Time Series Subsequence</em>, In Proc. ICDM'05 (2005)<br>
    [2] Wei, L., Keogh, E., Xi, X.,<em> SAXually explicit images: Finding unusual shapes</em>, In Proc. ICDM (2006)<br>
    [3] Fu, A., Leung, O., Keogh, E., Lin, J., <em> Finding Time Series Discords based on Haar Transform</em>, In Proc. of Intl. Conf. on Adv. Data Mining and Applications (2006)<br>
    [4] Bu, Y., Leung, O., Fu, A., Keogh, E., Pei, J., Meshkin, S.,<em> WAT: Finding Top-K Discords in Time Series Database</em>, In Proc. of SIAM Intl. Conf. on Data Mining (2007)<br>
    [5] Yankov, D., Keogh, E., Rebbapragada, U.,<em> Disk aware discord discovery: finding unusual time series in terabyte sized data sets </em>, Knowledge and Information Systems, 241-262 (2008)<br>
    [6] Lin, J., Keogh, E., Lonardi, S., Lankford, J.P., Nystrom, D. M.,<em> Visually mining and monitoring massive time series}</em>, In Proc. ACM SIGKDD Intn`l Conf. on KDD (2004)<br>
    [7] Chen, X., Zhan, Y.,<em> Multi-scale Anomaly Detection Algorithm based on Infrequent Pattern of Time Series</em>, J. of Computational and Applied Mathematics (2008)<br>
    [8] Wei, L., Kumar, N., Lolla, V., Keogh, E., Lonardi, S., Ratanamahatana, C.,<em> Assumption-free Anomaly Detection in Time Series}</em>, In Proc. SSDBM (2005)<br>
    [9] Arning, A., Agrawal, R., Raghavan, P.,<em> A Linear Method for Deviation Detection in Large Databases</em>, In KDD (pp. 164-169) (1996)<br>
    [10] Keogh, E., Lonardi, S., Ratanamahatana, C.A.,<em> Towards parameter-free data mining</em>, In Proc. KDD (2004)<br>
    [11] Chandola, V., Cheboli, D., and Kumar, V.,<em> Detecting Anomalies in a Time Series Database,</em> CS TR 09--004 (2009)

       </p>
       </div>
       </div>

  </div>
 </div>

</div>
