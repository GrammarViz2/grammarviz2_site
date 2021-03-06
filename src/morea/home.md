---
title: Home
morea_id: home
morea_type: home
---

<div class="section-background-1" itemscope="" itemtype="http://schema.org/SoftwareApplication">
<div class="container-fluid">
<div class="row top-buffer">
  <div class="col-md-12">
   <h2><strong>Welcome to GrammarViz 3.0 homepage!</strong></h2>
   <h4><span itemprop="applicationCategory">Open source Java tool for time series pattern mining</span> that runs on virtually <span itemprop="operatingSystem">all</span> platforms.</h4>
   <h5><i>Quick links: GUI-based discovery of 
    <a href="http://grammarviz2.github.io/grammarviz2_site/morea/anomaly/experience-a1.html">anomaly</a> and
    <a href="http://grammarviz2.github.io/grammarviz2_site/morea/motif/experience-m1.html">motif</a>; command line use for
    <a href="http://grammarviz2.github.io/grammarviz2_site/morea/anomaly/experience-a2.html">anomaly</a> and
    <a href="http://grammarviz2.github.io/grammarviz2_site/morea/motif/experience-m2.html">motif</a> discovery;
    <a href="https://github.com/GrammarViz2/grammarviz2_src">the sourcecode</a>.</i>
   </h5>
 </div>
</div>
</div>
</div>

<div class="section-background-2">
<div class="container-fluid">
<div class="row top-buffer">
    <div class="col-sm-9">
      <h3><strong>Time series anomaly and recurrent pattern discovery made interactive</strong></h3>
      <p>GrammarViz approach for time series pattern discovery is based on two algorithms that have linear time and space complexity:
         (i) <a href="http://www.cs.gmu.edu/~jessica/sax.htm">Symbolic Aggregate approXimation</a> (SAX), that discretizes the input time
         series into a string, and (ii) <a href="http://www.sequitur.info/">Sequitur</a>, that induces a context-free grammar (CFG) from it.
         Recently, we added another grammar induction algorithm called 
         <a href="http://ieeexplore.ieee.org/document/892708/?arnumber=892708">Re-Pair</a>, which is a bit slower than Sequitur, but powers
         an additional capability of our tool -- the automated discretization parameters selection.  
      </p>
      <p>By exploiting the hierarchical structure of CFG, GrammarViz is able to identify rare and frequent grammar rules
         <a href="https://www.youtube.com/watch?v=9lH-RG5OtkY"><em>in real time</em></a>, i.e., along with the signal acquisition.
         Naturally, we associate these patterns with anomalous and recurrent sub-sequences.
         Thanks to SAX numerosity reduction and CFG hierarchy, our approach is able to discover patterns of both types that are of variable length.
      </p>
      <p>Please find details about our techniques in these publications:<br>
        <ul>
         <li><a href="http://csdl.ics.hawaii.edu/techreports/2014/14-05/14-05.pdf"> Time series anomaly discovery with grammar-based compression</a>,<br>
         Senin, P., Lin, J., Wang, X., Oates, T., Gandhi, S., Boedihardjo, A.P., Chen, C., Frankenstein, S., EDBT 2015.<br></li>
         <li><a href="http://csdl.ics.hawaii.edu/techreports/2014/14-06/14-06.pdf">GrammarViz 2.0: a tool for grammar-based pattern discovery in time series</a>,<br>
         Senin, P., Lin, J., Wang, X., Oates, T., Gandhi, S., Boedihardjo, A.P., Chen, C., Frankenstein, S., Lerner, M., ECML/PKDD, 2014.<br></li>
         <li><a href="http://www.cs.gmu.edu/~jessica/publications/grammar_motif_sdm12.pdf">Visualizing Variable-Length Time Series Motifs</a>,<br>
         Yuan Li, Jessica Lin, Tim Oates, SDM 2012.</li>
        </ul>
      </p>
    </div>
    <div class="col-sm-3">
      <img style="margin-top: 50px; margin-bottom: 15px" src="morea/assets/lisa_sax.gif" width="181px" class="img-responsive center-block">
    </div>
</div>
</div>
</div>

<div class="section-background-1">
<div class="container-fluid">
<div class="row top-buffer">
    <div class="col-sm-3">
      <img style="margin-top: 20px; margin-bottom: 15px" src="morea/assets/java.png" width="120px" class="img-circle img-responsive center-block">
    </div>
    <div class="col-sm-9">
      <h3><strong>User and developer friendly platform</strong></h3>
      <p>GrammarViz 3.0 is developed in Java and runs on all platforms.
         It can be used as a stand-alone application with GUI, called from a command line, or linked as a library.
         For GUI, we followed the Model–view–controller (MVC) pattern which allows for the code re-use, for example in a web applicaion.
         Our code is hosted at <a href="https://github.com/GrammarViz2/grammarviz2_src">GitHub</a>, we care about it, and using
         <a href="https://travis-ci.org/GrammarViz2/grammarviz2_src">Travis CI</a> to track our builds.
      </p>
    </div>
</div>
</div>
</div>

<div class="section-background-2">
<div class="container-fluid">
<div class="row top-buffer">
    <div class="col-sm-9">
      <h3><strong>Roadmap</strong></h3>
      <p>Our software is under active development. Among other things, we are investigating alternative GI algorithms performance,
         researching the possibility to leverage a grammar's hierarchy for patterns weighting, and working on the system's performance
         and usability.
      </p>
    </div>
    <div class="col-sm-3">
      <img style="margin-top: 20px; margin-bottom: 15px" src="morea/assets/rose-grammar.png" width="160px" class="img-responsive center-block">
    </div>
</div>
</div>
</div>
