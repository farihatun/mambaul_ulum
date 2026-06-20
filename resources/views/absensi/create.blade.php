@extends('layouts.admin')

@section('content')

<div class="card shadow">

    <div class="card-header bg-success text-white">

        Tambah Absensi

    </div>

    <div class="card-body">

        <form action="{{ route('absensi.store') }}"
              method="POST">

            @csrf

            <div class="mb-3">

                <label>User</label>

                <select
                    name="user_id"
                    class="form-control"
                    required>

                    <option value="">
                        Pilih User
                    </option>

                    @foreach($users as $user)

                    <option value="{{ $user->id }}">

                        {{ $user->name }}

                    </option>

                    @endforeach

                </select>

            </div>

            <div class="mb-3">

                <label>Tanggal</label>

                <input
                    type="date"
                    name="tanggal"
                    class="form-control"
                    required>

            </div>

            <div class="mb-3">

                <label>Status</label>

                <select
                    name="status"
                    class="form-control">

                    <option value="Hadir">Hadir</option>
                    <option value="Izin">Izin</option>
                    <option value="Sakit">Sakit</option>
                    <option value="Alpa">Alpa</option>

                </select>

            </div>

            <button class="btn btn-success">

                Simpan

            </button>

            <a href="{{ route('absensi.index') }}"
               class="btn btn-secondary">

                Kembali

            </a>

        </form>

    </div>

</div>

@endsection
