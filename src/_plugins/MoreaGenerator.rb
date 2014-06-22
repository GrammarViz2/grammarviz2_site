# Processes pages in the morea directory.
# Adapted from: https://github.com/bbakersmith/jekyll-pages-directory

module Jekyll

  class MoreaGenerator < Generator

    attr_accessor :summary

    def configSite(site)
      site.config['morea_module_pages'] = []
      site.config['morea_outcome_pages'] = []
      site.config['morea_reading_pages'] = []
      site.config['morea_experience_pages'] = []
      site.config['morea_assessment_pages'] = []
      site.config['morea_home_page'] = nil
      site.config['morea_footer_page'] = nil
      site.config['morea_page_table'] = {}
      site.config['morea_fatal_errors'] = false

    end

    def generate(site)
      puts "\nStarting Morea page processing..."
      @fatal_errors = false
      configSite(site)
      @summary = MoreaGeneratorSummary.new(site)
      morea_dir = site.config['morea_dir'] || 'morea'
      morea_file_paths = Dir["#{site.source}/#{morea_dir}/**/*"]
      morea_file_paths.each do |f|
        if File.file?(f) and !hasIgnoreDirectory?(f)
          file_name = f.match(/[^\/]*$/)[0]
          relative_file_path = f.gsub(/^#{morea_dir}\//, '')
          relative_file_path = relative_file_path[(site.source.size + morea_dir.size + 1)..relative_file_path.size]
          subdir = extract_directory(relative_file_path)

          @summary.total_files += 1
          puts "  Processing file:  #{subdir}#{file_name}"
          if File.extname(file_name) == '.md'
            @summary.morea_files += 1
            processMoreaFile(site, subdir, file_name, morea_dir)
          else
            @summary.non_morea_files += 1
            processNonMoreaFile(site, subdir, file_name, morea_dir)
          end
        end
      end

      # Now that all Morea files are read in, do analyses that require access to all files.
      check_for_undeclared_morea_id_references(site)
      set_referencing_modules(site)
      set_referencing_assessment(site)
      print_morea_problems(site)
      check_for_undefined_home_page(site)
      check_for_undefined_footer_page(site)
      sort_pages(site)
      puts @summary
      if site.config['morea_fatal_errors']
        puts "Errors found. Exiting."
        exit
      end
    end

    def hasIgnoreDirectory?(path)
      #if Pathname(path).each_filename.to_a.include?("_ignore")
      #  puts "  Ignoring " + path
      #end
      return Pathname(path).each_filename.to_a.include?("_ignore")
    end

    def sort_pages(site)
      site.config['morea_module_pages'] = site.config['morea_module_pages'].sort_by {|page| page.data['morea_sort_order']}
      site.config['morea_outcome_pages'] = site.config['morea_outcome_pages'].sort_by {|page| page.data['morea_sort_order']}
      site.config['morea_reading_pages'] = site.config['morea_reading_pages'].sort_by {|page| page.data['morea_sort_order']}
      site.config['morea_experience_pages'] = site.config['morea_experience_pages'].sort_by {|page| page.data['morea_sort_order']}
      site.config['morea_assessment_pages'] = site.config['morea_assessment_pages'].sort_by {|page| page.data['morea_sort_order']}
    end

    # Tell each outcome all the modules that referred to it.
    def set_referencing_modules(site)
      site.config['morea_module_pages'].each do |module_page|
        module_page.data['morea_outcomes'].each do |outcome_id|
          outcome = site.config['morea_page_table'][outcome_id]
          if outcome
            unless module_page.data['morea_coming_soon']
              outcome.data['referencing_modules'] << module_page
            end
          end
        end
      end
    end

    # Tell each outcome all the assessments that referred to it.
    def set_referencing_assessment(site)
      site.config['morea_assessment_pages'].each do |assessment_page|
        assessment_page.data['morea_outcomes_assessed'].each do |outcome_id|
          outcome = site.config['morea_page_table'][outcome_id]
          if outcome
            unless assessment_page.data['morea_coming_soon']
              outcome.data['morea_referencing_assessments'] << assessment_page
            end
          end
        end
      end
    end

    def print_morea_problems(site)
      site.config['morea_page_table'].each do |morea_id, morea_page|
        morea_page.print_problems_if_any
      end
    end

    def check_for_undefined_home_page(site)
      unless site.config['morea_home_page']
        puts "  Warning:  no home page content. Define a page with 'morea_type: home' to fix."
        @summary.yaml_warnings += 1
      end
    end

    def check_for_undefined_footer_page(site)
      unless site.config['morea_footer_page']
        puts "  Warning:  no footer content. Define a page with 'morea_type: footer' to fix."
        @summary.yaml_warnings += 1
      end
    end


    def check_for_undeclared_morea_id_references(site)
      site.config['morea_page_table'].each do |morea_id, morea_page|

        # Check that morea_outcomes_assessed are all valid morea IDs.
        # If so, add the associated instance to morea_related_outcomes
        if morea_page.data['morea_outcomes_assessed']
          morea_page.data['morea_outcomes_assessed'].each do |morea_id_reference|
            if site.config['morea_page_table'][morea_id_reference]
              morea_page.data['morea_related_outcomes'] << site.config['morea_page_table'][morea_id_reference]
            else
              morea_page.undefined_id << morea_id_reference
              @summary.yaml_errors += 1
            end
          end
        end

        # Check for required tags for module pages.
        if (morea_page.data['morea_type'] == 'module')
          if morea_page.data['morea_outcomes']
            morea_page.data['morea_outcomes'].each do |morea_id_reference|
              unless site.config['morea_page_table'][morea_id_reference]
                morea_page.undefined_id << morea_id_reference
                @summary.yaml_errors += 1
              end
            end
          end
          if morea_page.data['morea_readings']
            morea_page.data['morea_readings'].each do |morea_id_reference|
              unless site.config['morea_page_table'][morea_id_reference]
                morea_page.undefined_id << morea_id_reference
                @summary.yaml_errors += 1
              end
            end
          end
          if morea_page.data['morea_experiences']
            morea_page.data['morea_experiences'].each do |morea_id_reference|
              unless site.config['morea_page_table'][morea_id_reference]
                morea_page.undefined_id << morea_id_reference
                @summary.yaml_errors += 1
              end
            end
          end
          if morea_page.data['morea_assessments']
            morea_page.data['morea_assessments'].each do |morea_id_reference|
              unless site.config['morea_page_table'][morea_id_reference]
                morea_page.undefined_id << morea_id_reference
                @summary.yaml_errors += 1
              end
            end
          end
        end
      end
    end

    # Copy all non-markdown files to destination directory unchanged.
    # Jekyll will create a morea directory in the destination that holds these files.
    def processNonMoreaFile(site, relative_dir, file_name, morea_dir)
      source_dir = morea_dir + "/" + relative_dir
      site.static_files << Jekyll::StaticFile.new(site, site.source, source_dir, file_name)
    end

    def processMoreaFile(site, subdir, file_name, morea_dir)
      new_page = MoreaPage.new(site, subdir, file_name, morea_dir)
      validate(new_page, site)
      # Ruby Newbie Alert. There is definitely a one liner to do the following:
      # Note that even pages with errors are going to try to be published.
      if new_page.published?
        @summary.published_files += 1
        site.pages << new_page
        site.config['morea_page_table'][new_page.data['morea_id']] = new_page
        if new_page.data['morea_type'] == 'module'
          site.config['morea_module_pages'] << new_page
          module_page = ModulePage.new(site, site.source, new_page.data['morea_id'], new_page)
          site.pages << module_page
        elsif new_page.data['morea_type'] == 'outcome'
          site.config['morea_outcome_pages'] << new_page
        elsif new_page.data['morea_type'] == "reading"
          site.config['morea_reading_pages'] << new_page
        elsif new_page.data['morea_type'] == "experience"
          site.config['morea_experience_pages'] << new_page
        elsif new_page.data['morea_type'] == "assessment"
          site.config['morea_assessment_pages'] << new_page
        elsif new_page.data['morea_type'] == "home"
          site.config['morea_home_page'] = new_page
        elsif new_page.data['morea_type'] == "footer"
          site.config['morea_footer_page'] = new_page
        end
      else
        @summary.unpublished_files += 1
      end
    end

    def extract_directory(filepath)
      dir_match = filepath.match(/(.*\/)[^\/]*$/)
      if dir_match
        return dir_match[1]
      else
        return ''
      end
    end

    def validate(morea_page, site)
      # Check for required tags: morea_id, morea_type, and title.
      if !morea_page.data['morea_id']
        morea_page.missing_required << "morea_id"
        @summary.yaml_errors += 1
      end
      if !morea_page.data['morea_type']
        morea_page.missing_required << "morea_type"
        @summary.yaml_errors += 1
      end
      if !morea_page.data['title']
        morea_page.missing_required << "title"
        @summary.yaml_errors += 1
      end

      # Check for required tags for experience and reading pages.
      if (morea_page.data['morea_type'] == 'experience') || (morea_page.data['morea_type'] == 'reading')
          if !morea_page.data['morea_summary']
          morea_page.missing_required << "morea_summary"
          @summary.yaml_errors += 1
        end
        if !morea_page.data['morea_url']
          # When not supplied we automatically generate the relative URL to the page.
          # Note we include the baseurl so that for readings and experiences, this link is absolute.
          morea_page.data['morea_url'] ="#{site.baseurl}#{morea_page.dir}/#{morea_page.basename}.html"
        end
      end

      # Check for required/optional tags for module pages.
      if (morea_page.data['morea_type'] == 'module')
        if !morea_page.data['morea_outcomes']
          morea_page.missing_optional << "morea_outcomes"
          morea_page.data['morea_outcomes'] = []
          @summary.yaml_warnings += 1
        end
        if !morea_page.data['morea_readings']
          morea_page.missing_optional << "morea_readings"
          morea_page.data['morea_readings'] = []
          @summary.yaml_warnings += 1
        end
        if !morea_page.data['morea_experiences']
          morea_page.missing_optional << "morea_experiences"
          morea_page.data['morea_experiences'] = []
          @summary.yaml_warnings += 1
        end
        if !morea_page.data['morea_assessments']
          morea_page.missing_optional << "morea_assessments"
          morea_page.data['morea_assessments'] = []
          @summary.yaml_warnings += 1
        end
        if !morea_page.data['morea_icon_url']
          morea_page.missing_optional << "morea_icon_url (set to /modules/default-icon.png)"
          morea_page.data['morea_icon_url'] = "/modules/default-icon.png"
          @summary.yaml_warnings += 1
        end
      end

      # Check for optional tags for non-home, footer pages
      if (morea_page.data['morea_type'] != 'home') && (morea_page.data['morea_type'] != 'footer')
        if !morea_page.data.has_key?('published')
          morea_page.missing_optional << "published (set to true)"
          morea_page.data['published'] = true
          @summary.yaml_warnings += 1
        end
        if !morea_page.data['morea_sort_order']
          morea_page.missing_optional << "morea_sort_order (set to 0)"
          morea_page.data['morea_sort_order'] = 0
          @summary.yaml_warnings += 1
        end
      end

      # Check for duplicate id
      if morea_page.data['morea_id'] && site.config['morea_page_table'].has_key?(morea_page.data['morea_id'])
        morea_page.duplicate_id = true
        @summary.yaml_errors += 1
      end
    end
  end


  # Every markdown file in the morea directory becomes a MoreaPage.
  class MoreaPage < Page
    attr_accessor :missing_required, :missing_optional, :duplicate_id, :undefined_id

    def initialize(site, subdir, file_name, morea_dir)
      read_yaml(File.join(site.source, morea_dir, subdir), file_name)
      @site = site
      @base = site.source
      @dir = morea_dir + "/" + subdir
      @name = file_name
      @missing_required = []
      @missing_optional = []
      @undefined_id = []
      @duplicate_id = false
      self.data['referencing_modules'] = []

      # Provide defaults
      if (self.data['morea_type'] == 'experience') || (self.data['morea_type'] == 'reading')
          unless self.data['layout']
          self.data['layout'] = 'default'
        end
        unless self.data['topdiv']
          self.data['topdiv'] = 'container'
        end
      end

      unless self.data['morea_related_outcomes']
        self.data['morea_related_outcomes'] = []
      end
      unless self.data['morea_outcomes_assessed']
        self.data['morea_outcomes_assessed'] = []
      end
      unless self.data['morea_referencing_assessments']
        self.data['morea_referencing_assessments'] = []
      end
      process(file_name)
      self.render(site.layouts, site.site_payload)

    end

    # Whether the file is published or not, as indicated in YAML front-matter
    # Ruby Newbie Alert: copied this from Convertible cause 'include Convertible' didn't work for me.
    def published?
      !(self.data.has_key?('published') && self.data['published'] == false)
    end

    # Prints a string listing warnings or errors if there were any, otherwise does nothing.
    def print_problems_if_any
      if @missing_required.size > 0
        puts "  Error: #{@name} missing required front matter: " + @missing_required*", "
        site.config['morea_fatal_errors'] = true
      end
      if @missing_optional.size > 0
        puts "  Warning: #{@name} missing optional front matter: " + @missing_optional*", "
      end
      if @duplicate_id
        puts "  Error: #{@name} has duplicate id: #{@data['morea_id']}"
        site.config['morea_fatal_errors'] = true
      end
      if @undefined_id.size > 0
        puts "  Error: #{@name} references undefined morea_id: " + @undefined_id*", "
        site.config['morea_fatal_errors'] = true
      end
    end
  end

  # Module pages are dynamically generated, one per MoreaPage with morea_type = module.
  class ModulePage < Page
    def initialize(site, base, dir, morea_page)
      self.read_yaml(File.join(base, '_layouts'), 'module.html')
      @site = site
      @base = base
      @dir = "modules/" + morea_page.data['morea_id']
      @name = 'index.html'

      self.process(@name)
      self.data['morea_page'] = morea_page
      morea_page.data['module_page'] = self
      self.data['title'] = morea_page.data['title']
    end
  end

  # Tallies the files processed in order to provide a summary at end of generator stage.
  class MoreaGeneratorSummary
    attr_accessor :total_files, :published_files, :unpublished_files, :morea_files, :non_morea_files, :yaml_warnings, :yaml_errors

    def initialize(site)
      @site = site
      @total_files = 0
      @published_files = 0
      @unpublished_files = 0
      @morea_files = 0
      @non_morea_files = 0
      @yaml_warnings = 0
      @yaml_errors = 0
    end

    def to_s
      "  Summary:\n    #{@total_files} total, #{@published_files} published, #{@unpublished_files} unpublished, #{@morea_files} markdown, #{@non_morea_files} other\n    #{@site.config['morea_module_pages'].size} modules, #{@site.config['morea_outcome_pages'].size} outcomes, #{@site.config['morea_reading_pages'].size} readings, #{@site.config['morea_experience_pages'].size} experiences, #{@site.config['morea_assessment_pages'].size} assessments\n    #{@yaml_errors} errors, #{@yaml_warnings} warnings"
    end
  end
end

