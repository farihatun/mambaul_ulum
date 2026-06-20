@extends('layouts.admin')

@section('content')

<div class="card shadow">

    <div class="card-header bg-warning">

        Edit Barzanji

    </div>

    <div class="card-body">

        <form action="{{ route('barzanji.update',$barzanji->id) }}"
              method="POST">

            @csrf
            @method('PUT')

            <div class="mb-3">

                <label>Judul Barzanji</label>

                <input
                    type="text"
                    name="judul"
                    value="{{ $barzanji->judul }}"
                    class="form-control"
                    required>

            </div>

            <div class="mb-3">

                <label>Isi Barzanji</label>

                <textarea
                    name="isi"
                    class="form-control"
                    rows="15"
                    required>{{ $barzanji->isi }}</textarea>

            </div>

            <button class="btn btn-primary">

                Update

            </button>

            <a href="{{ route('barzanji.index') }}"
               class="btn btn-secondary">

               Kembali

            </a>

        </form>

    </div>

</div>

@endsection
