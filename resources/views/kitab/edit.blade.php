@extends('layouts.admin')

@section('content')

<div class="card shadow">

    <div class="card-header bg-warning">

        Edit Kitab

    </div>

    <div class="card-body">

        <form
            action="{{ route('kitab.update',$kitab->id) }}"
            method="POST"
            enctype="multipart/form-data">

            @csrf
            @method('PUT')

            <div class="mb-3">

                <label>Judul Kitab</label>

                <input
                    type="text"
                    name="judul"
                    value="{{ $kitab->judul }}"
                    class="form-control"
                    required>

            </div>

            <div class="mb-3">

                <label>Deskripsi</label>

                <textarea
                    name="deskripsi"
                    class="form-control"
                    rows="5">{{ $kitab->deskripsi }}</textarea>

            </div>

            <div class="mb-3">

                <label>PDF Saat Ini</label>

                <br>

                <a href="{{ asset('uploads/kitab/'.$kitab->file_pdf) }}"
                   target="_blank">

                    Lihat PDF

                </a>

            </div>

            <div class="mb-3">

                <label>Ganti PDF</label>

                <input
                    type="file"
                    name="file"
                    class="form-control">

            </div>

            <button class="btn btn-primary">

                Update

            </button>

            <a href="{{ route('kitab.index') }}"
               class="btn btn-secondary">

               Kembali

            </a>

        </form>

    </div>

</div>

@endsection
