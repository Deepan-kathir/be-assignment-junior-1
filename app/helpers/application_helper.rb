module ApplicationHelper

  def link_to_add_fields(name = nil, f = nil, association = nil, options = nil, html_options = nil, &block)

    # If a block is provided there is no name attribute and the arguments are
    # shifted with one position to the left. This re-assigns those values.

    f, association, options, html_options = name, f, association, options if block_given?
    options = {} if options.nil?
    html_options = {'data-form-index': 1} if html_options.nil?

    if options.include? :locals
      locals = options[:locals]
    else
      locals = { }
    end

    if options.include? :partial
      partial = options[:partial]
    else
      partial = association.to_s.singularize + '_fields'
    end

    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: 'new_record') do |builder|
      render(partial, locals.merge!( f: builder))
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options['data-form-prepend'] = raw CGI::escapeHTML( fields )
    html_options['href'] = 'javascript:void(0)'
    html_options['class'] = 'mb-3'
    html_options['data-form-index'] = html_options['data-form-index']
    content_tag(:a, name, html_options, &block)
  end

  def get_user_name(user)
    return "" if user.nil?

    user.name.present? ? user.name : user.email
  end

  def get_payer_user_name(payer_id)
    payer_id_name_hash = current_user.payer_id_name_hash
    payer_id_name_hash.has_key?(payer_id) ? payer_id_name_hash[payer_id] : ""
  end

end
