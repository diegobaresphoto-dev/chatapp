import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Device } from './entities/device.entity';
import { PreKey } from './entities/prekey.entity';
import { User } from './entities/user.entity';

@Injectable()
export class KeysService {
    constructor(
        @InjectRepository(Device)
        private deviceRepository: Repository<Device>,
        @InjectRepository(PreKey)
        private preKeyRepository: Repository<PreKey>,
        @InjectRepository(User)
        private userRepository: Repository<User>,
    ) { }

    async uploadKeys(userId: string, data: any) {
        const user = await this.userRepository.findOne({ where: { id: userId } });

        // Find or create device (MVP logic: deviceId = 1)
        let device = await this.deviceRepository.findOne({
            where: { user: { id: userId }, deviceId: data.deviceId || 1 }
        });

        if (!device) {
            device = this.deviceRepository.create({
                user,
                deviceId: data.deviceId || 1
            });
        }

        device.identityPublicKey = data.identityPublicKey;
        device.signedPreKeyId = data.signedPreKey.id;
        device.signedPreKeyPublic = data.signedPreKey.publicKey;
        device.signedPreKeySignature = data.signedPreKey.signature;
        device.lastSeen = new Date();

        await this.deviceRepository.save(device);

        // Save one-time prekeys
        if (data.oneTimePreKeys && Array.isArray(data.oneTimePreKeys)) {
            const keys = data.oneTimePreKeys.map(k => this.preKeyRepository.create({
                device,
                keyId: k.id,
                publicKey: k.publicKey,
            }));
            await this.preKeyRepository.save(keys);
        }

        return { success: true };
    }

    async getPreKeyBundle(userId: string) {
        const device = await this.deviceRepository.findOne({
            where: { user: { id: userId } },
            relations: ['user'],
        });

        if (!device) {
            throw new NotFoundException('Dispositivo no encontrado para el usuario');
        }

        // Get one unused one-time prekey
        const preKey = await this.preKeyRepository.findOne({
            where: { device: { id: device.id }, isUsed: false },
        });

        if (preKey) {
            preKey.isUsed = true;
            await this.preKeyRepository.save(preKey);
        }

        return {
            userId: device.user.id,
            deviceId: device.deviceId,
            identityPublicKey: device.identityPublicKey,
            signedPreKey: {
                id: device.signedPreKeyId,
                publicKey: device.signedPreKeyPublic,
                signature: device.signedPreKeySignature,
            },
            oneTimePreKey: preKey ? {
                id: preKey.keyId,
                publicKey: preKey.publicKey,
            } : null,
        };
    }
}
