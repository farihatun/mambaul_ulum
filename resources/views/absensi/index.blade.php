@extends('layouts.admin')

@section('content')

<div class="d-flex justify-content-between mb-4">

    <h3>Data Absensi</h3>

    <a href="{{ route('absensi.create') }}"
       class="btn btn-success">

        + Tambah Absensi

    </a>

</div>

<div class="card shadow">

    <div class="card-body">

        <table class="table table-bordered table-hover">

            <thead class="table-success">

                <tr>
                    <th>No</th>
                    <th>Nama</th>
                    <th>Tanggal</th>
                    <th>Status</th>
                    <th>Aksi</th>
                </tr>

            </thead>

            <tbody>

                @forelse($absensi as $item)

                <tr>

                    <td>{{ $loop->iteration }}</td>

                    <td>{{ $item->user->name ?? '-' }}</td>

                    <td>{{ $item->tanggal }}</td>

                    <td>

                        @if($item->status == 'Hadir')

                            <span class="badge bg-success">
                                Hadir
                            </span>

                        @elseif($item->status == 'Izin')

                            <span class="badge bg-warning">
                                Izin
                            </span>

                        @elseif($item->status == 'Sakit')

                            <span class="badge bg-info">
                                Sakit
                            </span>

                        @else

                            <span class="badge bg-danger">
                                Alpa
                            </span>

                        @endif

                    </td>

                    <td>

                        <a href="{{ route('absensi.edit',$item->id) }}"
                           class="btn btn-warning btn-sm">

                           Edit

                        </a>

                        <form
                            action="{{ route('absensi.destroy',$item->id) }}"
                            method="POST"
                            class="d-inline">

                            @csrf
                            @method('DELETE')

                            <button
                                class="btn btn-danger btn-sm"
                                onclick="return confirm('Yakin hapus?')">

                                Hapus

                            </button>

                        </form>

                    </td>

                </tr>

                @empty

                <tr>

                    <td colspan="5" class="text-center">

                        Belum ada data absensi

                    </td>

                </tr>

                @endforelse

            </tbody>

        </table>

    </div>

</div>

@endsection
