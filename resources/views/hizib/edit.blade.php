@extends('layouts.admin')

@section('content')

<div class="card shadow">

    <div class="card-header bg-warning">

        Edit Hizib

    </div>

    <div class="card-body">

        <form action="{{ route('hizib.update',$hizib->id) }}"
              method="POST">

            @csrf
            @method('PUT')

            <div class="mb-3">

                <label>Judul Hizib</label>

                <input
                    type="text"
                    name="judul"
                    value="{{ $hizib->judul }}"
                    class="form-control"
                    required>

            </div>

            <div class="mb-3">

                <label>Isi Hizib</label>

                <textarea
                    name="isi"
                    class="form-control"
                    rows="15"
                    required>{{ $hizib->isi }}</textarea>

            </div>

            <button class="btn btn-primary">

                Update

            </button>

            <a href="{{ route('hizib.index') }}"
               class="btn btn-secondary">

               Kembali

            </a>

        </form>

    </div>

</div>

@endsection
