{{ Illuminate\Mail\Markdown::parse('---') }}

Thank you,<br>
{{ config('app.name') ?? 'Qlify Platform' }}

{{ Illuminate\Mail\Markdown::parse('[Contact Support](https://qlify.craetion.cl/docs/contact)') }}
