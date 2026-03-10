import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { User } from './entities/user.entity';
import { Invitation } from './entities/invitation.entity';
import { Device } from './entities/device.entity';
import { PreKey } from './entities/prekey.entity';
import { KeysService } from './keys.service';
import { KeysController } from './keys.controller';
import { JwtStrategy } from './jwt.strategy';
import { JwtAuthGuard } from './guards/jwt-auth.guard';

@Module({
    imports: [
        TypeOrmModule.forFeature([User, Invitation, Device, PreKey]),
        PassportModule,
        JwtModule.register({
            secret: process.env.JWT_SECRET || 'secret',
            signOptions: { expiresIn: '7d' },
        }),
    ],
    providers: [AuthService, KeysService, JwtStrategy, JwtAuthGuard],
    controllers: [AuthController, KeysController],
    exports: [AuthService, JwtAuthGuard],
})
export class AuthModule { }
