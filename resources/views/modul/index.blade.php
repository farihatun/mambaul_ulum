@extends('layouts.admin')

@section('content')

<style>

.page-title{
    font-weight:700;
    color:#065f46;
}

.upload-card{
    border:none;
    border-radius:25px;
    background:linear-gradient(135deg,#10b981,#059669);
    color:white;
    overflow:hidden;
    box-shadow:0 15px 30px rgba(16,185,129,.25);
}

.upload-card::before{
    content:"";
    position:absolute;
    width:200px;
    height:200px;
    background:rgba(255,255,255,.08);
    border-radius:50%;
    right:-50px;
    top:-50px;
}

.btn-upload{
    background:white;
    color:#065f46;
    font-weight:600;
    border:none;
    border-radius:12px;
}

.modul-card{
    border:none;
    border-radius:22px;
    overflow:hidden;
    transition:.3s;
    box-shadow:0 8px 20px rgba(0,0,0,.08);
}

.modul-card:hover{
    transform:translateY(-5px);
}

.icon-file{
    width:70px;
    height:70px;
    display:flex;
    align-items:center;
    justify-content:center;
    border-radius:20px;
    background:#ecfdf5;
    color:#059669;
    font-size:30px;
}

.badge-modul{
    background:#dcfce7;
    color:#166534;
    padding:8px 12px;
    border-radius:30px;
}

</style>

<div class="d-flex justify-content-between align-items-center mb-4">

    <div>
        <h3 class="page-title">
            📚 Modul Pembelajaran
        </h3>

        <small class="text-muted">
            Kelola seluruh materi pembelajaran santri
        </small>
    </div>

    <div class="d-flex gap-2">

        <!-- Tombol Upload -->
        <a href="{{ route('modul.create') }}"
           class="btn btn-success rounded-pill">

            <i class="bi bi-plus-circle"></i>
            Upload Modul

        </a>

    </div>

</div>

<!-- CARD UPLOAD -->

<div class="card upload-card mb-4 position-relative">

    <div class="card-body p-4">

        <h4>
            📖 Modul Santri
        </h4>

        <p>
            Upload PDF, DOCX, PPT atau materi pembelajaran lainnya.
            File yang diupload akan langsung tersedia pada aplikasi user.
        </p>

        <a href="{{ route('modul.create') }}"
           class="btn btn-upload">

           <i class="bi bi-cloud-upload"></i>
           Upload Sekarang

        </a>

    </div>

</div>

<!-- DATA MODUL -->

<div class="row g-4">

@forelse($moduls as $modul)

<div class="col-md-4">

    <div class="card modul-card h-100">

        <div class="card-body">

            <div class="d-flex justify-content-between">

                <div class="icon-file">
                    <i class="bi bi-file-earmark-pdf"></i>
                </div>

                <span class="badge-modul">
                    Modul
                </span>

            </div>

            <h5 class="mt-3">
                {{ $modul->judul }}
            </h5>

            <p class="text-muted">
                {{ Str::limit($modul->deskripsi, 100) }}
            </p>

            <hr>

            <div class="d-flex gap-2">

                <a href="{{ asset('storage/'.$modul->file) }}"
                   target="_blank"
                   class="btn btn-success flex-fill">

                    <i class="bi bi-eye"></i>
                    Lihat

                </a>

                <a href="{{ route('modul.edit',$modul->id) }}"
                   class="btn btn-warning">

                    <i class="bi bi-pencil"></i>

                </a>

                <form action="{{ route('modul.destroy',$modul->id) }}"
                      method="POST">

                    @csrf
                    @method('DELETE')

                    <button class="btn btn-danger"
                            onclick="return confirm('Yakin ingin menghapus modul ini?')">

                        <i class="bi bi-trash"></i>

                    </button>

                </form>

            </div>

        </div>

    </div>

</div>

@empty

<div class="col-12">

    <div class="card border-0 shadow-sm rounded-4">

        <div class="card-body text-center py-5">

            <i class="bi bi-folder-x text-success"
               style="font-size:70px;"></i>

            <h5 class="mt-3">
                Belum Ada Modul
            </h5>

            <p class="text-muted">
                Upload modul pertama untuk santri.
            </p>

        </div>

    </div>

</div>

@endforelse

</div>

@endsection
