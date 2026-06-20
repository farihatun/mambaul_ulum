@extends('layouts.admin')

@section('content')

<div class="card shadow border-0">

    <div class="card-header bg-danger text-white">
        <h5 class="mb-0">📖 Al-Barzanji</h5>
    </div>

    <div class="card-body p-0">

        <iframe
            src="{{ asset('uploads/Al-barzanji.pdf') }}"
            width="100%"
            height="900"
            style="border:none;">
        </iframe>

    </div>

</div>

@endsection
