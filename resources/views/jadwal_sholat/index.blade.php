@extends('layouts.admin')

@section('content')

<style>

/* HEADER */
.page-title{
    font-weight:800;
    color:#0f766e;
}

/* BACKGROUND CARD INFO */
.info-card{
    border: none;
    border-radius: 20px;
    background: linear-gradient(135deg, #ffffff, #f0fdfa);
    box-shadow: 0 10px 30px rgba(0,0,0,.06);
}

/* CLOCK BOX */
.jam-box{
    background: linear-gradient(135deg,#0f766e,#14b8a6);
    color:white;
    border-radius:22px;
    padding:30px;
    text-align:center;
    box-shadow:0 15px 35px rgba(0,0,0,.15);
    position:relative;
    overflow:hidden;
}

.jam-box::before{
    content:"";
    position:absolute;
    width:200px;
    height:200px;
    background:rgba(255,255,255,.1);
    border-radius:50%;
    top:-60px;
    right:-60px;
}

.clock-time{
    font-size:42px;
    font-weight:800;
    letter-spacing:2px;
}

/* CARD SHOLAT */
.jadwal-card{
    border:none;
    border-radius:18px;
    background: white;
    box-shadow:0 10px 25px rgba(0,0,0,.06);
    transition:all .25s ease;
    overflow:hidden;
    position:relative;
}

.jadwal-card:hover{
    transform:translateY(-6px);
    box-shadow:0 15px 35px rgba(0,0,0,.12);
}

/* LEFT ACCENT COLOR */
.jadwal-card::before{
    content:"";
    position:absolute;
    left:0;
    top:0;
    width:6px;
    height:100%;
    background: linear-gradient(180deg,#0f766e,#14b8a6);
}

/* BADGE TIME */
.badge-sholat{
    background: linear-gradient(135deg,#ecfeff,#d1fae5);
    color:#0f766e;
    padding:7px 14px;
    border-radius:999px;
    font-weight:700;
    font-size:14px;
    box-shadow: inset 0 0 0 1px rgba(15,118,110,.2);
}

/* GRID SPACING */
.prayer-grid{
    margin-top:10px;
}

</style>

<!-- HEADER -->
<div class="d-flex justify-content-between align-items-center mb-4">

    <div>
        <h3 class="page-title">🕌 Jadwal Sholat {{ $city ?? 'Lokasi' }}</h3>
        <small class="text-muted">
            Data otomatis dari API Aladhan
        </small>
    </div>

</div>

<!-- INFO HARI -->
<div class="card info-card mb-4">
    <div class="card-body d-flex justify-content-between align-items-center">

        <div>
            <h6 class="mb-1 fw-bold">Hari Ini</h6>
            <small class="text-muted">
                {{ now()->translatedFormat('l, d F Y') }}
            </small>
        </div>

        <div class="text-end">
            <small class="text-muted">Waktu Server</small><br>
            <strong id="clock"></strong>
        </div>

    </div>
</div>

<!-- JAM BESAR -->
<div class="jam-box mb-4">
    <h5 class="mb-2">Waktu Sekarang</h5>
    <div class="clock-time" id="clockBig">00:00:00</div>
</div>

@php
    $sholat = [
        'Fajr' => ['label' => 'Subuh', 'icon' => '🌙'],
        'Dhuhr' => ['label' => 'Dzuhur', 'icon' => '☀️'],
        'Asr' => ['label' => 'Ashar', 'icon' => '🌤️'],
        'Maghrib' => ['label' => 'Maghrib', 'icon' => '🌇'],
        'Isha' => ['label' => 'Isya', 'icon' => '🌌'],
    ];
@endphp

<div class="row g-4 prayer-grid">

    @foreach($sholat as $key => $item)

    <div class="col-md-4 col-lg-4">

        <div class="card jadwal-card p-3">

            <div class="d-flex justify-content-between align-items-center">

                <div>
                    <div class="fw-bold fs-5">
                        {{ $item['icon'] }} {{ $item['label'] }}
                    </div>
                    <small class="text-muted">Waktu sholat wajib</small>
                </div>

                <span class="badge-sholat">
                    {{ $timings[$key] ?? '--:--' }}
                </span>

            </div>

        </div>

    </div>

    @endforeach

</div>

<script>

function updateClock(){
    const now = new Date();

    const time = now.toLocaleTimeString('id-ID', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });

    document.getElementById('clock').innerText = time;
    document.getElementById('clockBig').innerText = time;
}

setInterval(updateClock,1000);
updateClock();

</script>

@endsection
