# AssociationTypeMismatchExampleApp

This is a bare bones Rails 4.2 app to demonstrate the lackluster feedback given
by AssociationTypeMismatch errors thrown when Rails users inadvertently send an
inapropriate type to an association writer attribute.

The app has only one model: `Course` which has only one interesting column:
`predecessor_id`. This column is used to define the following relationship:

```ruby
has_one :replacement, class_name: "Course", foreign_key: :predecessor_id
belongs_to :predecessor, class_name: "Course"
```

A Course can have a predecessor (defined by its `predecessor_id`) and a
replacement (defined by another course whose `predecessor_id` matches its own
`id`).

If one naively creates the following `collection_select` the Course edit form
in order to assign the replacement for the current course:

```ruby
<%= f.collection_select :replacement, Course.all, :id, :title %>
```

When the form is submitted the following params will be sent to the
`CoursesController#update` action:

```ruby
{"utf8"=>"✓",
"_method"=>"patch",
"authenticity_token"=>"Dnj4pqNtp4k0RpxylF7ETiyQInkUwNlTYdUaY+eVPDPoM9LZRY/cXdpGsqx96HARbdDzrG3V20W+7xk9wMMw7A==",
"course"=>{"title"=>"Old Course",
"replacement"=>"2"},
"commit"=>"Update Course",
"id"=>"1"}
```

This will trigger an `ActiveRecord::AssociationTypeMismatch` exception with the
following message: `Course(#70220544658260) expected, got String(#70220534703980)`.

This message makes it very difficult to figure out what is going on because it
doesn't explain that the `replacement=` method was called or that it received
the argument `"2"` (a String), when this association writer was expecting a
whole Course instance.

## Reproduction steps

1. clone this repo
2. run `bin/setup`
3. run `bin/rails server`
4. open http://localhost:3000/
5. you'll be redirected to the edit form, just click `Update Course`
6. you will see the error page
