export class RegisterDto {
    email: string;
    username: string;
    password: string;
    invitationCode: string;
}

export class LoginDto {
    identifier: string; // email or username
    password: string;
}
