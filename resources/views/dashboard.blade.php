@extends('layouts.admin')

@section('content')

<style>

.dashboard-banner{
    background:
    linear-gradient(
        135deg,
        #0f766e,
        #059669
    );

    border-radius:25px;
    color:white;
    overflow:hidden;
    position:relative;
    padding:35px;
    margin-bottom:25px;
}

.dashboard-banner::before{
    content:"";
    position:absolute;
    width:250px;
    height:250px;
    right:-70px;
    top:-70px;
    background:rgba(255,255,255,.08);
    border-radius:50%;
}

.dashboard-banner::after{
    content:"";
    position:absolute;
    width:180px;
    height:180px;
    left:-50px;
    bottom:-50px;
    background:rgba(255,255,255,.08);
    border-radius:50%;
}

.logo-banner{
    width:100px;
    height:100px;
    background:white;
    border-radius:50%;
    padding:10px;
    object-fit:contain;
    box-shadow:0 10px 20px rgba(0,0,0,.2);
}

.menu-card{
    border:none;
    border-radius:20px;
    overflow:hidden;
    transition:.35s;
    color:white;
    min-height:150px;
}

.menu-card:hover{
    transform:translateY(-8px);
}

.menu-card i{
    font-size:40px;
}

.stat-card{
    border:none;
    border-radius:20px;
    box-shadow:0 5px 20px rgba(0,0,0,.08);
    transition:.3s;
}

.stat-card:hover{
    transform:translateY(-5px);
}

.time-info {
    background: rgba(255,255,255,0.15);
    border-radius: 20px;
    padding: 8px 18px;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255,255,255,0.1);
    margin-top: 12px;
}

.time-info i {
    font-size: 18px;
}

</style>

<div class="dashboard-banner">

    <div class="row align-items-center">

        <div class="col-md-9">

            <h2 class="fw-bold">
                Assalamu'alaikum 👋
            </h2>

            <h4>
                Selamat Datang di Sistem Informasi
                Pondok Pesantren Mamba'ul Ulum
            </h4>

            <p class="mb-0">
                Kelola Modul, Absensi, Hizib, Kitab,
                dan Al-Barzanji dalam satu dashboard.
            </p>

            <!-- Info Waktu Sholat Berikutnya -->
            <div class="time-info">
                <i class="bi bi-clock"></i>
                <span id="jamSekarang" style="font-weight: 600;">
                    {{ date('H:i:s') }}
                </span>
                <span style="opacity:0.5;">|</span>
                <i class="bi bi-moon-stars"></i>
                <span>
                    Menuju {{ $nextPrayer ?? 'Dzuhur' }}
                    <span style="font-weight: 600; color: #fcd34d;">{{ $nextPrayerTime ?? '12:15' }}</span>
                </span>
                <span style="opacity:0.5;">|</span>
                <span id="countdownSholat" style="font-weight: 600; color: #fcd34d;">
                    {{ $countdown ?? '00:00:00' }}
                </span>
            </div>

        </div>

        <div class="col-md-3 text-center">

            <img
                src="{{ asset('images/logo.png') }}"
                class="logo-banner">

        </div>

    </div>

</div>

<div class="row g-4">

    <div class="col-md-4">

        <a href="{{ route('modul.index') }}"
           class="text-decoration-none">

            <div class="card menu-card"
                 style="background:linear-gradient(135deg,#10b981,#059669);">

                <div class="card-body">

                    <i class="bi bi-book-half"></i>

                    <h4 class="mt-3">
                        Modul
                    </h4>

                    <small>
                        Materi Pembelajaran
                    </small>

                </div>

            </div>

        </a>

    </div>

    <div class="col-md-4">

        <a href="{{ route('absensi.index') }}"
           class="text-decoration-none">

            <div class="card menu-card"
                 style="background:linear-gradient(135deg,#f59e0b,#ea580c);">

                <div class="card-body">

                    <i class="bi bi-clipboard-check"></i>

                    <h4 class="mt-3">
                        Absensi
                    </h4>

                    <small>
                        Kehadiran Santri
                    </small>

                </div>

            </div>

        </a>

    </div>

    <div class="col-md-4">

        <a href="{{ route('hizib.index') }}"
           class="text-decoration-none">

            <div class="card menu-card"
                 style="background:linear-gradient(135deg,#8b5cf6,#6366f1);">

                <div class="card-body">

                    <i class="bi bi-book"></i>

                    <h4 class="mt-3">
                        Hizib
                    </h4>

                    <small>
                        Hizib Nahdlatul Wathan
                    </small>

                </div>

            </div>

        </a>

    </div>

    <div class="col-md-4">

        <a href="{{ route('kitab.index') }}"
           class="text-decoration-none">

            <div class="card menu-card"
                 style="background:linear-gradient(135deg,#0ea5e9,#2563eb);">

                <div class="card-body">

                    <i class="bi bi-journal-bookmark"></i>

                    <h4 class="mt-3">
                        Tuhfatul Athfal
                    </h4>

                    <small>
                        Kitab Tajwid
                    </small>

                </div>

            </div>

        </a>

    </div>

    <div class="col-md-4">

        <a href="{{ route('barzanji.index') }}"
           class="text-decoration-none">

            <div class="card menu-card"
                 style="background:linear-gradient(135deg,#ec4899,#db2777);">

                <div class="card-body">

                    <i class="bi bi-book"></i>

                    <h4 class="mt-3">
                        Al-Barzanji
                    </h4>

                    <small>
                        Maulid Nabi
                    </small>

                </div>

            </div>

        </a>

    </div>

    <div class="col-md-4">

        <a href="{{ route('jadwal_sholat') }}"
           class="text-decoration-none">

            <div class="card menu-card"
                 style="background:linear-gradient(135deg,#14b8a6,#06b6d4);">

                <div class="card-body">

                    <i class="bi bi-clock-history"></i>

                    <h4 class="mt-3">
                        Jadwal Sholat
                    </h4>

                    <small>
                        Waktu Sholat Harian
                    </small>

                </div>

            </div>

        </a>

    </div>

</div>

<!-- Statistik - Hanya 2 Kolom: Absensi dan Modul -->
<div class="row mt-4 justify-content-center">

    <div class="col-md-5 mb-3">

        <div class="card stat-card">

            <div class="card-body text-center">

                <i class="bi bi-clipboard-data fs-1 text-primary"></i>

                <h2>{{ $jumlahAbsensi ?? 0 }}</h2>

                <p class="mb-0">Total Absensi</p>

            </div>

        </div>

    </div>

    <div class="col-md-5 mb-3">

        <div class="card stat-card">

            <div class="card-body text-center">

                <i class="bi bi-book fs-1 text-success"></i>

                <h2>{{ $jumlahModul ?? 0 }}</h2>

                <p class="mb-0">Total Modul</p>

            </div>

        </div>

    </div>

</div>

@endsection

@push('scripts')
<script>
function updateClock() {
    const now = new Date();
    const jam = String(now.getHours()).padStart(2, '0');
    const menit = String(now.getMinutes()).padStart(2, '0');
    const detik = String(now.getSeconds()).padStart(2, '0');
    document.getElementById('jamSekarang').textContent = jam + ':' + menit + ':' + detik;
}

function updateCountdown() {
    const now = new Date();
    const target = new Date();
    target.setHours(12, 15, 0, 0);

    let diff = target - now;

    if (diff < 0) {
        target.setDate(target.getDate() + 1);
        diff = target - now;
    }

    const hours = Math.floor(diff / 3600000);
    const minutes = Math.floor((diff % 3600000) / 60000);
    const seconds = Math.floor((diff % 60000) / 1000);

    const countdown = String(hours).padStart(2, '0') + ':' +
                      String(minutes).padStart(2, '0') + ':' +
                      String(seconds).padStart(2, '0');

    document.getElementById('countdownSholat').textContent = countdown;
}

setInterval(updateClock, 1000);
setInterval(updateCountdown, 1000);
updateClock();
updateCountdown();
</script>
@endpush
