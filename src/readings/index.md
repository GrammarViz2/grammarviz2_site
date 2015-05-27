---
layout: default
title: Readings
---

<div class="container">
  <h1>Presentations</h1>
</div>

<div class="section-background-1">
  <div class="container">
   <div class="row">
    <div class="col-sm-4">
        <script async class="speakerdeck-embed" data-id="7b79415d9e9d4c9c9ac075a1c5743a12"
          data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
     </div>
     <div class="col-sm-4">
        <script async class="speakerdeck-embed" data-id="3336d38017de01329f66460735b58e3e"
          data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
     </div>
     <div class="col-sm-4">
        <script async class="speakerdeck-embed" data-id="21b7703da5a44d42925e6a5212367be9"
          data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
     </div>
   </div>
 </div>
</div>

<div class="container">
  <h1>Videos and tutorials</h1>
</div>

<div class="row">
  <div class="container">
    <div class="col-md-10">
         <div class="embed-responsive embed-responsive-16by9">
           <iframe width="480" height="310" class="embed-responsive-item" src="//www.youtube.com/embed/9lH-RG5OtkY" frameborder="0" allowfullscreen></iframe>
         </div>
    </div>
  </div>
</div>

<div class="container">
  <h1>Readings and other resources <small>in module order</small></h1>
</div>

{% for module in site.morea_module_pages %}
{% if module.morea_coming_soon != true and module.morea_readings.size > 0 %}
<div class="{% cycle 'section-background-1', 'section-background-2' %}">
  <div class="container">
    <h2><small>Module:</small> <a href="{{ site.baseurl }}{{ module.module_page.url }}">{{ module.title }}</a></h2>

    <div class="row">
    {% for page_id in module.morea_readings %}
      {% assign reading = site.morea_page_table[page_id] %}
       <div class="col-sm-3">
         <div class="thumbnail">
           <h4><a href="{{ reading.morea_url }}">{{ reading.title }}</a></h4>
             {{ reading.morea_summary | markdownify }}
             <p>
             {% for label in reading.morea_labels %}
               <span class="badge">{{ label }}</span>
             {% endfor %}
             </p>
         </div>
       </div>
        {% if forloop.index == 4 %}
          </div><div class="row">
        {% endif %}
        {% if forloop.index == 8 %}
          </div><div class="row">
        {% endif %}
       {% if forloop.index == 12 %}
          </div><div class="row">
        {% endif %}
        {% if forloop.index == 16 %}
          </div><div class="row">
        {% endif %}
    {% endfor %}
    </div>
  </div>
</div>
{% endif %}
{% endfor %}
