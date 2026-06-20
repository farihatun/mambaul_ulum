@extends('layouts.admin')

@section('content')

<style>
.profile-card{
    border:none;
    border-radius:20px;
    box-shadow:0 10px 25px rgba(0,0,0,.08);
}

.eye-btn{
    border:none;
    background:transparent;
}
</style>

<div class="card profile-card">

    <div class="card-header bg-success text-white">
        <h5 class="mb-0">
            <i class="bi bi-person-circle"></i> Profil Admin
        </h5>
    </div>

    <div class="card-body">

        <form action="{{ route('profile.update') }}" method="POST">
            @csrf

            <!-- NAMA -->
            <div class="mb-3">
                <label>Nama</label>
                <input type="text"
                       name="name"
                       value="{{ Auth::user()->name }}"
                       class="form-control">
            </div>

            <!-- EMAIL + EYE -->
            <div class="mb-3">
                <label>Email</label>

                <div class="input-group">
                    <input type="text"
                           id="email"
                           name="email"
                           value="{{ Auth::user()->email }}"
                           class="form-control">

                    <button type="button"
                            class="btn btn-outline-secondary eye-btn"
                            onclick="toggleEmail()">

                        <i id="eyeEmail" class="bi bi-eye"></i>

                    </button>
                </div>
            </div>

            <!-- PASSWORD + EYE -->
            <div class="mb-3">
                <label>Password Baru</label>

                <div class="input-group">
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control"
                           placeholder="Kosongkan jika tidak diubah">

                    <button type="button"
                            class="btn btn-outline-secondary eye-btn"
                            onclick="togglePassword()">

                        <i id="eyePassword" class="bi bi-eye"></i>

                    </button>
                </div>
            </div>

            <button class="btn btn-success">
                <i class="bi bi-check-circle"></i> Simpan
            </button>

        </form>

    </div>
</div>

<script>

// PASSWORD SHOW/HIDE
function togglePassword(){
    let pass = document.getElementById("password");
    let icon = document.getElementById("eyePassword");

    if(pass.type === "password"){
        pass.type = "text";
        icon.classList.remove("bi-eye");
        icon.classList.add("bi-eye-slash");
    }else{
        pass.type = "password";
        icon.classList.remove("bi-eye-slash");
        icon.classList.add("bi-eye");
    }
}

// EMAIL SHOW/HIDE
function toggleEmail(){
    let email = document.getElementById("email");
    let icon = document.getElementById("eyeEmail");

    if(email.type === "password"){
        email.type = "text";
    }else{
        email.type = "password";
    }

    // toggle icon juga
    if(icon.classList.contains("bi-eye")){
        icon.classList.remove("bi-eye");
        icon.classList.add("bi-eye-slash");
    }else{
        icon.classList.remove("bi-eye-slash");
        icon.classList.add("bi-eye");
    }
}

</script>

@endsection
