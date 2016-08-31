---
layout: default
title: Learning Outcomes
---

<<<<<<< HEAD
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

>>>>>>> core/master
<div class="container">
  <h1>Learning Outcomes</h1>
</div>

<<<<<<< HEAD
{% if site.morea_outcome_pages.size == 0 %}
<p>No outcomes for this course.</p>
=======
{% if site.morea_overview_outcomes %}
<div class="container">
  {{ site.morea_overview_outcomes.content | markdownify }}
</div>
{% endif %}

{% if site.morea_outcome_pages.size == 0 %}
<div class="container">
  <p>No outcomes for this course.</p>
</div>
>>>>>>> core/master
{% endif %}


{% for outcome in site.morea_outcome_pages %}

{% if outcome.referencing_modules.size > 0 %}

<div class="{% cycle 'section-background-1', 'section-background-2' %}">
  <div class="container">
<<<<<<< HEAD
    <a style="padding-top: 50px; margin-top: -50px; display: table-caption;" name="{{ outcome.morea_id }}"></a><h3><small>{{ forloop.index }}.</small> {{ outcome.title }}</h3>
=======
    <a style="padding-top: 50px; margin-top: -50px; display: table-caption;" name="{{ outcome.morea_id }}"></a><h3>{{ outcome.title }}</h3>
>>>>>>> core/master
    <p>
      {% for label in outcome.morea_labels %}
         <span class="badge">{{ label }}</span>
      {% endfor %}
    </p>
    {{ outcome.content | markdownify }}
    <p>
    <em>Referencing modules:</em>
    {% for module in outcome.referencing_modules %}
      <a href="../modules/{{ module.morea_id }}">{{ module.title }}</a>{% unless forloop.last %}, {% endunless %}
    {% endfor %}
    </p>
    {% unless outcome.morea_referencing_assessments.size == 0 %}
       <p>
        <em>Assessed by:</em>
        {% for assessment in outcome.morea_referencing_assessments %}
<<<<<<< HEAD
          <a href="../assessments/#{{ assessment.morea_id }}">{{ assessment.title }}</a>{% unless forloop.last %}, {% endunless %}
=======
          {% unless assessment.referencing_modules.size == 0 %}
            <a href="../assessments/#{{ assessment.morea_id }}">{{ assessment.title }}</a>{% unless forloop.last %}, {% endunless %}
          {% endunless %}
>>>>>>> core/master
        {% endfor %}
        </p>
    {% endunless %}

  </div>
</div>

{% endif %}

{% endfor %}


