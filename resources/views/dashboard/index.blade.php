@extends('layouts.admin')

@section('content')

<div class="d-flex justify-content-between align-items-center mb-4">

    <div>

        <h2 class="fw-bold text-success">
            Assalamu'alaikum 👋
        </h2>

        <p class="text-muted mb-0">
            Selamat datang di Dashboard Admin Mambaul Ulum
        </p>

    </div>

    <div class="text-end">

        <h4 id="clock" class="fw-bold text-success"></h4>

        <span id="date" class="text-muted"></span>

    </div>

</div>

<div class="row g-4">

    <div class="col-md-4">

        <div class="card border-0 shadow-lg rounded-4">

            <div class="card-body">

                <div class="d-flex justify-content-between">

                    <div>

                        <h6>Total Absensi</h6>

                        <h1 class="fw-bold text-success">
                            {{ $jumlahAbsensi }}
                        </h1>

                    </div>

                    <i class="bi bi-calendar-check fs-1 text-success"></i>

                </div>

            </div>

        </div>

    </div>

    <div class="col-md-4">

        <div class="card border-0 shadow-lg rounded-4">

            <div class="card-body">

                <div class="d-flex justify-content-between">

                    <div>

                        <h6>Total Modul</h6>

                        <h1 class="fw-bold text-primary">
                            {{ $jumlahModul }}
                        </h1>

                    </div>

                    <i class="bi bi-journal-bookmark fs-1 text-primary"></i>

                </div>

            </div>

        </div>

    </div>

    <div class="col-md-4">

        <div class="card border-0 shadow-lg rounded-4">

            <div class="card-body">

                <div class="d-flex justify-content-between">

                    <div>

                        <h6>Total Kitab</h6>

                        <h1 class="fw-bold text-warning">
                            {{ $jumlahKitab }}
                        </h1>

                    </div>

                    <i class="bi bi-book fs-1 text-warning"></i>

                </div>

            </div>

        </div>

    </div>

</div>

<div class="row g-4 mt-2">

    <div class="col-md-6">

        <div class="card border-0 shadow-lg rounded-4">

            <div class="card-body">

                <div class="d-flex justify-content-between">

                    <div>

                        <h6>Total Hizib</h6>

                        <h1 class="fw-bold text-info">
                            {{ $jumlahHizib }}
                        </h1>

                    </div>

                    <i class="bi bi-stars fs-1 text-info"></i>

                </div>

            </div>

        </div>

    </div>

    <div class="col-md-6">

        <div class="card border-0 shadow-lg rounded-4">

            <div class="card-body">

                <div class="d-flex justify-content-between">

                    <div>

                        <h6>Total Barzanji</h6>

                        <h1 class="fw-bold text-danger">
                            {{ $jumlahBarzanji }}
                        </h1>

                    </div>

                    <i class="bi bi-journal-richtext fs-1 text-danger"></i>

                </div>

            </div>

        </div>

    </div>

</div>

<div class="card border-0 shadow-lg rounded-4 mt-4">

    <div class="card-body text-center">

        <h4 class="text-success fw-bold">
            🕌 Sistem Informasi Pondok Pesantren Mambaul Ulum
        </h4>

        <p class="text-muted">
            Kelola Absensi, Modul, Kitab, Hizib dan Barzanji dengan mudah.
        </p>

    </div>

</div>

<script>

function updateClock() {

    const now = new Date();

    const time = now.toLocaleTimeString('id-ID');

    const date = now.toLocaleDateString('id-ID', {
        weekday:'long',
        year:'numeric',
        month:'long',
        day:'numeric'
    });

    document.getElementById('clock').innerHTML = time;

    document.getElementById('date').innerHTML = date;
}

setInterval(updateClock,1000);

updateClock();

</script>

@endsection
