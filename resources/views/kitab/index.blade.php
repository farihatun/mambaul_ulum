@extends('layouts.admin')

@section('content')

<div class="card shadow border-0">

    <div class="card-header bg-primary text-white">
        <h5 class="mb-0">
            📚 Kitab Tuhfatul Athfal
        </h5>
    </div>

    <div class="card-body p-0">

        <iframe
            src="{{ asset('uploads/Tuhfatul-Athfal.pdf') }}"
            width="100%"
            height="900"
            style="border:none;">
        </iframe>

    </div>

</div>

@endsection
