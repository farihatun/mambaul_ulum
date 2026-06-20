@extends('layouts.admin')

@section('content')

<div class="card shadow">

    <div class="card-header bg-warning">

        Edit Absensi

    </div>

    <div class="card-body">

        <form action="{{ route('absensi.update',$absensi->id) }}"
              method="POST">

            @csrf
            @method('PUT')

            <div class="mb-3">

                <label>User</label>

                <select
                    name="user_id"
                    class="form-control">

                    @foreach($users as $user)

                    <option
                        value="{{ $user->id }}"
                        {{ $absensi->user_id == $user->id ? 'selected' : '' }}>

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
                    value="{{ $absensi->tanggal }}"
                    class="form-control">

            </div>

            <div class="mb-3">

                <label>Status</label>

                <select
                    name="status"
                    class="form-control">

                    <option value="Hadir" {{ $absensi->status=='Hadir'?'selected':'' }}>
                        Hadir
                    </option>

                    <option value="Izin" {{ $absensi->status=='Izin'?'selected':'' }}>
                        Izin
                    </option>

                    <option value="Sakit" {{ $absensi->status=='Sakit'?'selected':'' }}>
                        Sakit
                    </option>

                    <option value="Alpa" {{ $absensi->status=='Alpa'?'selected':'' }}>
                        Alpa
                    </option>

                </select>

            </div>

            <button class="btn btn-primary">

                Update

            </button>

            <a href="{{ route('absensi.index') }}"
               class="btn btn-secondary">

                Kembali

            </a>

        </form>

    </div>

</div>

@endsection
