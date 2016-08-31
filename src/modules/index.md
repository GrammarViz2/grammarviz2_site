---
layout: default
title: Modules
---

<<<<<<< HEAD
<div class="container">
  <h1>Modules <small>Topics covered in tutorials.</small></h1>
  <div class="row">
     {% for module in site.morea_module_pages %}
        <div class="col-sm-3">
        {% if module.morea_highlight %}
          <div class="thumbnail section-background-1">
        {% else %}
          <div class="thumbnail">
        {% endif %}
            {% if module.morea_coming_soon %}
              <img src="{{ site.baseurl }}{{ module.morea_icon_url }}" width="100" class="img-circle img-responsive morea-img-hover">
            {% else %}
              <a href="{{ module.morea_id }}" role="button"><img src="{{ site.baseurl }}{{ module.morea_icon_url }}" width="100" class="img-circle img-responsive morea-img-hover"></a>
            {% endif %}
            <div class="caption">
              <h3 style="text-align: center; margin-top: 0">{{ forloop.index }}. {{ module.title }}</h3>
              {{ module.content | markdownify }}
=======
<div class="breadcrumb-bar">
  <div class="container">
    <ol class="breadcrumb">
        {% if site.morea_head_breadcrumb_link %}
          <li><a href="{{ site.morea_head_breadcrumb_link }}">{{ site.morea_head_breadcrumb_label }}</a></li>
          {% endif %}
      <li><a href="{{ site.baseurl }}/">Home</a></li>
      <li class="active">{{ page.title }}</li>
    </ol>
  </div>
</div>

<div class="container">
  <h1>Modules <small>Topics covered in this class.</small></h1>
  
  {% if site.morea_overview_modules %}
    {{ site.morea_overview_modules.content | markdownify }}
  {% endif %}
  
  <div class="row">
     {% for module in site.morea_module_pages %}
        <div class="col-sm-3">
        
        {% if module.morea_coming_soon %}
          <div class="thumbnail">
            <img src="{{ site.baseurl }}{{ module.morea_icon_url }}" width="100" class="img-circle img-responsive">
            <div class="caption">
              <h3 style="text-align: center; margin-top: 0">{{ forloop.index }}. {{ module.title }}</h3>
              {{ module.morea_summary | markdownify }}
>>>>>>> core/master
              <p>
              {% for label in module.morea_labels %}
                <span class="badge">{{ label }}</span>
              {% endfor %}
              </p>
<<<<<<< HEAD
              {% if module.morea_coming_soon %}
                <p class="text-center"><a href="#" class="btn btn-default" role="button">Coming soon...</a></p>
              {% else %}
                <p class="text-center"><a href="{{ module.morea_id }}" class="btn btn-primary" role="button">Learn more...</a></p>
              {% endif %}
            </div>
          </div>
        </div>
=======
              <p class="text-center"><b>Coming soon...</b></p>
            </div>
          </div>
        {% else %}
          <a href= "{{ module.morea_id }}" class="thumbnail">
            <img src="{{ site.baseurl }}{{ module.morea_icon_url }}" width="100" class="img-circle img-responsive">
            <div class="caption">
              <h3 style="text-align: center; margin-top: 0">{{ forloop.index }}. {{ module.title }}</h3>
              {{ module.morea_summary | markdownify }}
              <p>
              {% for label in module.morea_labels %}
                <span class="badge">{{ label }}</span>
              {% endfor %}
              </p>
              
            </div>
          </a>
        {% endif %}
        </div>
         
>>>>>>> core/master
       {% cycle '', '', '', '</div><div class="row">' %}
     {% endfor %}
  </div>
</div>


