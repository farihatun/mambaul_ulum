@extends('layouts.admin')

@section('content')

<div class="card shadow">

    <div class="card-header bg-success text-white">

        Tambah Hizib

    </div>

    <div class="card-body">

        <form action="{{ route('hizib.store') }}"
              method="POST">

            @csrf

            <div class="mb-3">

                <label>Judul Hizib</label>

                <input
                    type="text"
                    name="judul"
                    class="form-control"
                    required>

            </div>

            <div class="mb-3">

                <label>Isi Hizib</label>

                <textarea
                    name="isi"
                    class="form-control"
                    rows="15"
                    required></textarea>

            </div>

            <button class="btn btn-success">

                Simpan

            </button>

            <a href="{{ route('hizib.index') }}"
               class="btn btn-secondary">

               Kembali

            </a>

        </form>

    </div>

</div>

@endsection
