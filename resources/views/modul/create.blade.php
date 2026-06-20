@extends('layouts.admin')

@section('content')

<div class="card shadow">

    <div class="card-header bg-success text-white">
        Tambah Modul
    </div>

    <div class="card-body">

        @if ($errors->any())
        <div class="alert alert-danger">
            <ul class="mb-0">
                @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
        @endif

        <form action="{{ route('modul.store') }}"
              method="POST"
              enctype="multipart/form-data">

            @csrf

            <div class="mb-3">
                <label class="form-label">
                    Judul Modul
                </label>

                <input type="text"
                       name="judul"
                       class="form-control"
                       required>
            </div>

            <div class="mb-3">
                <label class="form-label">
                    Deskripsi
                </label>

                <textarea name="deskripsi"
                          class="form-control"
                          rows="4"></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">
                    Upload PDF
                </label>

                <input type="file"
                       name="file"
                       class="form-control"
                       accept=".pdf"
                       required>
            </div>

            <button type="submit"
                    class="btn btn-success">

                Simpan
            </button>

            <a href="{{ route('modul.index') }}"
               class="btn btn-secondary">

                Kembali
            </a>

        </form>

    </div>

</div>

@endsection
