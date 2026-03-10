import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { User } from './entities/user.entity';
import { Invitation } from './entities/invitation.entity';
import { RegisterDto, LoginDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
    constructor(
        @InjectRepository(User)
        private userRepository: Repository<User>,
        @InjectRepository(Invitation)
        private invitationRepository: Repository<Invitation>,
        private jwtService: JwtService,
    ) { }

    async register(dto: RegisterDto) {
        // 1. Validate invitation
        const invite = await this.invitationRepository.findOne({ where: { code: dto.invitationCode } });
        if (!invite || invite.uses >= invite.maxUses) {
            throw new BadRequestException('Invitación inválida o agotada');
        }
        if (invite.expiresAt && invite.expiresAt < new Date()) {
            throw new BadRequestException('Invitación expirada');
        }

        // 2. Check if user exists
        const existing = await this.userRepository.findOne({
            where: [{ email: dto.email }, { username: dto.username }],
        });
        if (existing) {
            throw new BadRequestException('Usuario o email ya existe');
        }

        // 3. Create user
        const passwordHash = await bcrypt.hash(dto.password, 10);
        const user = this.userRepository.create({
            email: dto.email,
            username: dto.username,
            passwordHash,
        });

        await this.userRepository.save(user);

        // 4. Consume invitation
        invite.uses++;
        await this.invitationRepository.save(invite);

        return this.login({ identifier: user.username, password: dto.password });
    }

    async login(dto: LoginDto) {
        const user = await this.userRepository.findOne({
            where: [{ email: dto.identifier }, { username: dto.identifier }],
        });

        if (!user || !(await bcrypt.compare(dto.password, user.passwordHash))) {
            throw new UnauthorizedException('Credenciales inválidas');
        }

        const payload = { sub: user.id, username: user.username, role: user.role };
        return {
            access_token: this.jwtService.sign(payload),
            user: {
                id: user.id,
                username: user.username,
                email: user.email,
                role: user.role,
            },
        };
    }
}
