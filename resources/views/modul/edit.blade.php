@extends('layouts.admin')

@section('content')

<div class="card shadow">

    <div class="card-header bg-warning">

        Edit Modul

    </div>

    <div class="card-body">

        <form
            action="{{ route('modul.update',$modul->id) }}"
            method="POST"
            enctype="multipart/form-data">

            @csrf
            @method('PUT')

            <div class="mb-3">

                <label class="form-label">
                    Judul Modul
                </label>

                <input
                    type="text"
                    name="judul"
                    value="{{ $modul->judul }}"
                    class="form-control"
                    required>

            </div>

            <div class="mb-3">

                <label class="form-label">
                    Deskripsi
                </label>

                <textarea
                    name="deskripsi"
                    class="form-control"
                    rows="5">{{ $modul->deskripsi }}</textarea>

            </div>

            <div class="mb-3">

                <label class="form-label">
                    PDF Saat Ini
                </label>

                <br>

                <a href="{{ asset('uploads/modul/'.$modul->file_pdf) }}"
                   target="_blank">

                    Lihat PDF

                </a>

            </div>

            <div class="mb-3">

                <label class="form-label">
                    Ganti PDF
                </label>

                <input
                    type="file"
                    name="file"
                    class="form-control">

            </div>

            <button
                type="submit"
                class="btn btn-primary">

                Update

            </button>

            <a href="{{ route('modul.index') }}"
               class="btn btn-secondary">

                Kembali

            </a>

        </form>

    </div>

</div>

@endsection
