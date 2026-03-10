import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Device } from './device.entity';

@Entity('prekeys')
export class PreKey {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column()
    keyId: number;

    @Column()
    publicKey: string; // Base64

    @Column({ default: false })
    isUsed: boolean;

    @ManyToOne(() => Device, (device) => device.preKeys)
    device: Device;
}
