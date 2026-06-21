@extends('layouts.admin')

@section('content')

<div class="container-fluid">


<div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold text-success">
        Data Absensi Santri
    </h3>

    <a href="{{ route('absensi.create') }}"
       class="btn btn-success">
        <i class="bi bi-plus-circle"></i>
        Tambah Absensi
    </a>
</div>

<div class="card border-0 shadow-lg rounded-4">

    <div class="card-body">

        <div class="table-responsive">

            <table class="table table-hover align-middle">

                <thead class="table-success">

                    <tr>
                        <th width="60">No</th>
                        <th>Nama Santri</th>
                        <th>Tanggal</th>
                        <th>Jam</th>
                        <th>Status</th>
                        <th>Keterangan</th>
                        <th width="180">Aksi</th>
                    </tr>

                </thead>

                <tbody>

                    @forelse($absensi as $item)

                    <tr>

                        <td>
                            {{ $loop->iteration }}
                        </td>

                        <td>
                            {{ $item->user->name ?? '-' }}
                        </td>

                        <td>
                            {{ $item->tanggal }}
                        </td>

                        <td>
                            {{ \Carbon\Carbon::parse($item->created_at)->format('H:i') }}
                        </td>

                        <td>

                            @switch($item->status)

                                @case('Hadir')
                                    <span class="badge bg-success px-3 py-2">
                                        Hadir
                                    </span>
                                    @break

                                @case('Izin')
                                    <span class="badge bg-warning px-3 py-2">
                                        Izin
                                    </span>
                                    @break

                                @case('Sakit')
                                    <span class="badge bg-info px-3 py-2">
                                        Sakit
                                    </span>
                                    @break

                                @default
                                    <span class="badge bg-danger px-3 py-2">
                                        Alpha
                                    </span>

                            @endswitch

                        </td>

                        <td>
                            {{ $item->keterangan ?? '-' }}
                        </td>

                        <td>

                            <a href="{{ route('absensi.edit', $item->id) }}"
                               class="btn btn-warning btn-sm">

                                Edit

                            </a>

                            <form action="{{ route('absensi.destroy', $item->id) }}"
                                  method="POST"
                                  class="d-inline">

                                @csrf
                                @method('DELETE')

                                <button type="submit"
                                        class="btn btn-danger btn-sm"
                                        onclick="return confirm('Yakin ingin menghapus data ini?')">

                                    Hapus

                                </button>

                            </form>

                        </td>

                    </tr>

                    @empty

                    <tr>

                        <td colspan="7"
                            class="text-center py-4">

                            Belum ada data absensi

                        </td>

                    </tr>

                    @endforelse

                </tbody>

            </table>

        </div>

    </div>

</div>


</div>

@endsection
