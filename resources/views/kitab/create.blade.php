@extends('layouts.admin')

@section('content')

<div class="card shadow">

    <div class="card-header bg-success text-white">

        Tambah Kitab

    </div>

    <div class="card-body">

        <form
            action="{{ route('kitab.store') }}"
            method="POST"
            enctype="multipart/form-data">

            @csrf

            <div class="mb-3">

                <label>Judul Kitab</label>

                <input
                    type="text"
                    name="judul"
                    class="form-control"
                    required>

            </div>

            <div class="mb-3">

                <label>Deskripsi</label>

                <textarea
                    name="deskripsi"
                    class="form-control"
                    rows="5"></textarea>

            </div>

            <div class="mb-3">

                <label>Upload PDF</label>

                <input
                    type="file"
                    name="file"
                    class="form-control"
                    accept=".pdf"
                    required>

            </div>

            <button class="btn btn-success">

                Simpan

            </button>

            <a href="{{ route('kitab.index') }}"
               class="btn btn-secondary">

               Kembali

            </a>

        </form>

    </div>

</div>

@endsection

